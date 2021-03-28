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
      .attr('class', `${CSSpluginClass} ${CSSpluginClassGroup}`) //TODO Irgendeine Native Klasse?
      .markup('>')
    // Multiple Anchors
    for (let x = 0; x < values.length; x++) {
      const val = values[x]
      // Display Item
      html
        .markup('<a')
        .attr('id', `${itemID}_${itemIdx}_0`)
        .attr('class', 'notEmpty a-Button u-info-text') // Style Button with Link Color
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
  pluginItem$
    .parents('div[id*="_ig"]')
    .on('click', `.${CSSpluginClass} a`, (e) => {
      // console.debug("click event for plugin: ", e)

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
