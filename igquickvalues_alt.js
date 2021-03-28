/**
 * Alternative version with 20.1 apex.item.attachHandler
 * Only for developing and testing purposes
 * @param {jQuery} context 
 */

const createPluginItem = (context) => {
  let itemIdx = 0

  const pluginname = 'igquickvalues' // Plugin Name zur einheitlichen Erstellung von Variablen
  /* CSS Variablen */
  const CSSpluginClass = pluginname // Markiert Plugin Dom Elemente
  const CSSpluginClassGroup = pluginname + '-group' // Parent mit bis zu mehreren Items
  const CSSpluginClassItem = pluginname + '-item' // Einzelnes Item
  const CSSpluginClassEnabled = pluginname + '-enabled' // Enabled State
  const CSSpluginClassDisabled = pluginname + '-disabled' // Disabled State
  console.timeLog("create Attached Handler");

  const pluginItem$ = context.find(`.apex-item-${pluginname}`)
  const itemID = pluginItem$.attr("id")

  readOnly = pluginItem$.data('readOnly')
  seperator = pluginItem$.data('seperator')
  column = pluginItem$.data('column')
  
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
        .attr('class', 'notEmpty a-Button u-info-text')
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
  // probably not the best solution
  pluginItem$
    .parents('div[id*="_ig"]')
    .on('click', `.${CSSpluginClass} a`, (e) => {

      // Set Value from Anchor to Grid Column
      const anchorBtn$ = $(e.currentTarget)
      saveValueToGridModel(anchorBtn$)
    })

  // Enable item
  if (readOnly) {
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
      if (readOnly) {
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

apex.item.addAttachHandler(createPluginItem)
