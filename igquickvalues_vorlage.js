// function renderQuickValuesAnchors(pContext$) {
//   $('input.apex-item-igquickvalues.apex-item-plugin', pContext$).each(
//     function () {
//       let itemIdx = 0
//       let itemAnchorsIdx = 0
//       const myItem = $(this)
//       const parentWrapper = myItem
//         .addClass('u-vh is-focusable')
//         .wrap(`<div class="apex-item-igquickvalues igquickvalues-item"></div>`)
//         .parent()

//       console.log('From Plugin JS', myItem, parentWrapper)
//       // Do what is needed to initialize the plug-in item element.
//       // Most likely call apex.item.create here.
//       const quickValues = myItem.val().split(myItem.data("seperator")) // Splits the Data in an array
//       console.log("quick values: ", quickValues)

//       const html = apex.util.htmlBuilder()
//       html
//         .markup('<div')
//         .attr("class", "apex-item-igquickvalues apex-item-plugin")
//         .markup(">")
//       quickValues.forEach(qv => {
//         html
//           .markup("<a")
//           .attr("onclick", `console.log("Plugin Anchor clicked, value: ", ${$(this).val()})`) // Onclick
//           .attr("class", `igquickvalues-anchor igquickvalues-anchor-${itemIdx}-${itemAnchorsIdx}`) // Anchor Classes
//           .markup(">")
//           .content(qv)
//           .markup("</a>")

//           itemAnchorsIdx++
//       })
//       html.markup("</div>")

//       console.log("html markup", html)

//       itemIdx++

//       parentWrapper.append(html.toString())
//     }
//   )
// }

// apex.item.addAttachHandler(renderQuickValuesAnchors)

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
        checkedValue: checkedValue,
        uncheckedValue: uncheckedValue,
        readOnly: readOnly,
      } = itemJSON

      let itemIdx = 0

      const pluginItem$ = $(`#${itemID}`)
      console.debug('pluginItem$', pluginItem$)

      const pluginItemParent$ = pluginItem$
        .addClass('u-vh is-focusable')
        .wrap(
          '<div class="ig-simple-checkbox ig-simple-checkbox-item ig-simple-checkbox-enabled"></div>'
        )
        .parent()
      console.debug('pluginItemParent$', pluginItemParent$)

      /**
       * Create non editable Item Markup
       */
      const getDisplayItemMarkup = (bool, value) => {
        const html = apex.util.htmlBuilder()
        return (
          html
            .markup('<div')
            .attr(
              'class',
              'ig-simple-checkbox checkbox_group apex-item-checkbox'
            )
            .markup('><input')
            .attr('type', 'checkbox')
            .attr('id', `${itemID}_${itemIdx}_0`)
            .attr('name', `${itemID}_${itemIdx}`)
            .attr('value', value)
            .attr('tabindex', -1)
            .attr('data-checked-value', checkedValue)
            .attr('data-unchecked-value', uncheckedValue)
            .optionalAttr('checked', value === checkedValue)
            .optionalAttr('disabled', readOnly)
            .markup(' /><label')
            .attr('for', `${itemID}_${itemIdx}_0`)
            .markup('>')
            .content('')
            .markup('</label>'),
          (itemIdx += 1),
          console.debug('getDisplayItemMarkup:', html),
          html.toString()
        )
      }

      const saveValueToGridModel = (jqueryItem$) => {
        // Spechert den Wert ins IG Grid Model
        const recordID = jqueryItem$.closest('tr').data('id')
        console.debug('saveValueToGridModel: recordID:', recordID)

        const regionID = $(jqueryItem$.parents('.a-IG')).attr('id').slice(0, -3) //Region Static ID
        console.debug('saveValueToGridModel: regionID:', regionID)

        const regionWidget = apex.region(regionID).widget()
        console.debug('saveValueToGridModel: regionWidget:', regionWidget)

        const { model: gridModel } = regionWidget.interactiveGrid(
          'getViews',
          'grid'
        )
        console.debug('saveValueToGridModel: gridModel:', gridModel)

        const record = gridModel.getRecord(recordID)
        console.debug('saveValueToGridModel: record:', record)

        const modelFields = regionWidget
          .interactiveGrid('getViews')
          .grid.model.getOption('fields')
        console.debug('saveValueToGridModel: modelFields:', modelFields)

        let columnField = ''

        Object.keys(modelFields).forEach((fieldIdx) => {
          if (modelFields[fieldIdx].elementId === itemID) {
            columnField = fieldIdx
          }
        })
        console.debug('saveValueToGridModel: columnField:', columnField)
        gridModel.setValue(record, columnField, jqueryItem$.val())
        console.debug('saveValueToGridModel: item Value:', jqueryItem$.val())
      }

      const SynchroniseItemInputs = () => {
        const editCheckbox$ = pluginItemParent$.find('input[type="checkbox"]')
        console.debug('SynchroniseItemInputs: editCheckbox$:', editCheckbox$)
        console.debug(
          'SynchroniseItemInputs: isChecked:',
          pluginItem$.val() === checkedValue
        )
        editCheckbox$.prop('checked', pluginItem$.val() === checkedValue),
          // Adds Space keyboard to the TD element around the Input
          (() => {
            $('.ig-simple-checkbox').each((elemIdx, elem) => {
              console.debug('SynchroniseItemInputs: loop .ig-simple-checkbox$:', $(elem))
              $(elem)
                .parents('td')
                .off('.igsimplecheckbox')
                .on('keydown.igsimplecheckbox', (event) => {
                  if (32 === event.which) {
                    const checkbox$ = $(elem).find('input[type="checkbox"]')
                    return (
                      pluginItem$
                        .val(
                          checkbox$.prop('checked')
                            ? uncheckedValue
                            : checkedValue
                        )
                        .trigger('change'),
                      saveValueToGridModel(pluginItem$),
                      SynchroniseItemInputs(),
                      false
                    )
                  }
                  return true
                })
            })
          })()
      }
      // apends DisplayMarkup to editable Item
      pluginItemParent$.append(getDisplayItemMarkup())
      // Add onChange Event listener for newly created Item
      pluginItemParent$.find('input[type="checkbox"]').on('change', (event) => {
        const checkbox$ = $(event.currentTarget)
        pluginItem$
          .val(checkbox$.prop('checked') ? checkedValue : uncheckedValue)
          .trigger('change')
        saveValueToGridModel(checkbox$)
        pluginItem$.trigger('focus')
      })

      SynchroniseItemInputs()

      // Enable item
      if (itemJSON.readOnly) {
        pluginItem$
          .closest('.ig-simple-checkbox')
          .removeClass('ig-simple-checkbox-disabled')
          .addClass('ig-simple-checkbox-enabled')
      }

      // create an Apex Item
      apex.item.create(itemID, {
        setValue(value) {
          pluginItem$.val(value)
          SynchroniseItemInputs()
        },
        disable() {
          pluginItem$
            .closest('.ig-simple-checkbox')
            .addClass('ig-simple-checkbox-disabled')
            .removeClass('ig-simple-checkbox-enabled')
          pluginItem$.prop('disabled', true)
        },
        enable() {
          if (itemJSON.readOnly) {
            pluginItem$
              .closest('.ig-simple-checkbox')
              .removeClass('ig-simple-checkbox-disabled')
              .addClass('ig-simple-checkbox-enabled')
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
