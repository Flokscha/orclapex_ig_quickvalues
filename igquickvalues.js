var de_fgrote_ig_quick_values = (function (a) {

  function b(d) {
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
    b((b.s = 0))
  )
})([
  function (a, b, c) {
    a.exports = c(1)
  },
  function (a, b, c) {
    'use strict'
    Object.defineProperty(b, '__esModule', { value: true }),
      c.d(b, 'init', function () {
        return createPluginItem
      })

    const createPluginItem = (itemID, itemJSON) => {
      const {
        readOnly: readOnly,
        seperator: seperator,
        column: column,
        linkClasses: linkClasses,
        linkAttributes: linkAttributes,
      } = itemJSON

      let itemIdx = 0

      const pluginname = 'igquickvalues'
      /* CSS Variables */
      const CSSpluginClass = pluginname // Marks Plugin DOM elements
      const CSSpluginClassGroup = pluginname + '-group' // Parent Element class that groups the anchors
      const CSSpluginClassItem = pluginname + '-item'
      const CSSpluginClassEnabled = pluginname + '-enabled'
      const CSSpluginClassDisabled = pluginname + '-disabled'

      const pluginItem$ = $(`#${itemID}`)

      const getDisplayItemMarkup = (bool, value) => {
        const html = apex.util.htmlBuilder()
        const values = value ? value.split(seperator) : ['']

        // Wrapping DIV
        html
          .markup('<div')
          .attr('class', `${CSSpluginClass} ${CSSpluginClassGroup}`)
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
        return html.toString()
      }

      const saveValueToGridModel = (jqueryItem$) => {
        const recordID = jqueryItem$.closest('tr').data('id')

        const regionID = $(jqueryItem$.parents('.a-IG')).attr('id').slice(0, -3) //Region Static ID

        const regionWidget = apex.region(regionID).widget()

        const { model: gridModel } = regionWidget.interactiveGrid(
          'getViews',
          'grid'
        )

        const record = gridModel.getRecord(recordID)

        gridModel.setValue(record, column, jqueryItem$.text())
      }

      // Add Event Handler for Click on Anchors
      // Probalby not the best solution
      pluginItem$.parents('div[id*="_ig"]').on("click", `.${CSSpluginClass} a`, (e) => {
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

      // create Apex Item
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
