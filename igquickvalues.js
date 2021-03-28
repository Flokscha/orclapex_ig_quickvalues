var de_fgrote_ig_quick_values = (function (a) {
  // console.debug('Export Parameter a: ', a) // 2 Funktionen mit den 3 Parametern

  function b(d) {
    // console.debug('Export function b parameter d: ', d) // Ein index zum Export
    // console.debug('Export function b parameter c: ', c) // Objekt mit Index und der exportierten Funktion (init)
    if (c[d]) return c[d].exports
    var e = (c[d] = { i: d, l: false, exports: {} })
    return a[d].call(e.exports, e, e.exports, b), (e.l = true), e.exports
  }
  var c = {}
  return (
    (b.m = a),
    (b.c = c),
    (b.d = function (a, c, d) {
      b.o(a, c) ||
        Object.defineProperty(a, c, {
          configurable: false,
          enumerable: true,
          get: d,
        })
    }),
    (b.n = function (a) {
      var c =
        a && a.__esModule
          ? function () {
              return a['default']
            }
          : function () {
              return a
            }
      return b.d(c, 'a', c), c
    }),
    (b.o = function (a, b) {
      return Object.prototype.hasOwnProperty.call(a, b)
    }),
    (b.p = ''),
    // console.debug('Export return b: ', b), // inefach die obere Funktion
    b((b.s = 0))
  )
})([
  function (a, b, c) {
    a.exports = c(1)
    // console.debug('Export call 1 parameter a b c: ', a, b, c) // a export objekt, b export Funktion only, c = B funktion
  },
  function (a, b, c) {
    'use strict'
    Object.defineProperty(b, '__esModule', { value: true }),
      c.d(b, 'init', function () {
        return createPluginItem
      })
    // console.debug('Export call 2 parameter a b c: ', a, b, c) // a export objekt, b export Funktion only, c = B funktion
    /**
     * @author Rafael Trevisan <rafael@trevis.ca>
     * @license
     * Copyright (c) 2018 Rafael Trevisan
     *
     * Permission is hereby granted, free of charge, to any person obtaining a copy
     * of this software and associated documentation files (the 'Software'), to deal
     * in the Software without restriction, including without limitation the rights
     * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
     * copies of the Software, and to permit persons to whom the Software is
     * furnished to do so, subject to the following players:
     *
     * The above copyright notice and this permission notice shall be included in all
     * copies or substantial portions of the Software.
     *
     * THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
     * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
     * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
     * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
     * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
     * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
     * SOFTWARE.
     */

    const createPluginItem = (itemID, itemJSON) => {
      const {
        // destructering JSON
        readOnly: readOnly,
        seperator: seperator,
        column: column,
        linkClasses: linkClasses,
        linkAttributes: linkAttributes,
      } = itemJSON

      let itemIdx = 0

      const pluginname = 'igquickvalues' // Plugin Name zur einheitlichen Erstellung von Variablen
      /* CSS Variablen */
      const CSSpluginClass = pluginname // Markiert Plugin Dom Elemente
      const CSSpluginClassGroup = pluginname + '-group' // Parent mit bis zu mehreren Items
      const CSSpluginClassItem = pluginname + '-item' // Einzelnes Item
      const CSSpluginClassEnabled = pluginname + '-enabled' // Enabled State
      const CSSpluginClassDisabled = pluginname + '-disabled' // Disabled State

      const pluginItem$ = $(`#${itemID}`)
      // console.debug('pluginItem$', pluginItem$)

      const getDisplayItemMarkup = (bool, value) => {
        const html = apex.util.htmlBuilder()
        const values = value ? value.split(seperator) : ['']

        // Wrapping DIV
        html
          .markup('<div')
          .attr('class', `${CSSpluginClass} ${CSSpluginClassGroup}`) //TODO Irgendeine Native Klasse?
          .markup('>')
        // Multiple Anchors
        for (let x = 0; x < values.length; x++) {
          const val = values[x]
          // Display Item
          html
            .markup('<a')
            .attr('id', `${itemID}_${itemIdx}_0`)
            .attr('class', linkClasses)
            .markup(linkAttributes)
            .attr('tabindex', -1)
            .optionalAttr('disabled', readOnly)
            .markup('>')
            .content(val)
            .markup('</a>')
          itemIdx += 1
        }
        // console.debug('getDisplayItemMarkup:', html)
        return html.toString()
      }

      const saveValueToGridModel = (jqueryItem$) => {
        // console.debug('saveValueToGridModel: jqueryItem$:', jqueryItem$)
        // Spechert den Wert ins IG Grid Model
        const recordID = jqueryItem$.closest('tr').data('id')
        // console.debug('saveValueToGridModel: recordID:', recordID)

        const regionID = $(jqueryItem$.parents('.a-IG')).attr('id').slice(0, -3) //Region Static ID
        // console.debug('saveValueToGridModel: regionID:', regionID)

        const regionWidget = apex.region(regionID).widget()
        // console.debug('saveValueToGridModel: regionWidget:', regionWidget)

        const { model: gridModel } = regionWidget.interactiveGrid(
          'getViews',
          'grid'
        )
        // console.debug('saveValueToGridModel: gridModel:', gridModel)

        const record = gridModel.getRecord(recordID)
        // console.debug('saveValueToGridModel: record:', record)

        gridModel.setValue(record, column, jqueryItem$.text())
        // console.debug('saveValueToGridModel: item Value:', jqueryItem$.text())
      }

      // Add Event Handler for Click on Anchors
      // Nicht die beste Lösung
      pluginItem$.parents('div[id*="_ig"]').on("click", `.${CSSpluginClass} a`, (e) => {
        // console.debug("click event for plugin: ", e)

        // Set Value from Anchor to Grid Column
        const anchorBtn$ = $(e.currentTarget)
        saveValueToGridModel(anchorBtn$)
      })

      // Enable item
      if (itemJSON.readOnly) {
        pluginItem$
          .closest(`.${CSSpluginClass}`)
          .removeClass(CSSpluginClassDisabled)
          .addClass(CSSpluginClassEnabled)
      }

      // create an Apex Item
      apex.item.create(itemID, {
        setValue(value) {
          pluginItem$.val(value)
        },
        disable() {
          pluginItem$
            .closest(`.${CSSpluginClass}`)
            .addClass(CSSpluginClassDisabled)
            .removeClass(CSSpluginClassEnabled)
          pluginItem$.prop('disabled', true)
        },
        enable() {
          if (itemJSON.readOnly) {
            pluginItem$
              .closest(`.${CSSpluginClass}`)
              .removeClass(CSSpluginClassDisabled)
              .addClass(CSSpluginClassEnabled)
            pluginItem$.prop('disabled', false)
          }
        },
        displayValueFor(value) {
          return getDisplayItemMarkup(true, value)
        },
      })
    }
  },
])
