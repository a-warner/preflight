window.ChecklistItem = React.createClass({
  formElement: function() { return React.findDOMNode(this.refs.form); },
  removeLink: function() { return React.findDOMNode(this.refs.removeLink); },
  row: function() { return React.findDOMNode(this.refs.row); },

  componentDidMount: function() {
    var self = this;

    $(this.formElement()).on('ajax:success.ChecklistItem', function(e, newItem) {
      if (self.newRecord()) {
        self.props.addChecklistItem(newItem);
        self.setState({formName: ''});
      } else {
        self.toggleEditMode();
        self.setState({item: newItem});
      }
    }).on('ajax:error.ChecklistItem', function(e, xhr) {
      alert(xhr.responseText)
    });

    $(this.removeLink()).on('ajax:success.ChecklistItem', function() {
      $(self.row()).slideUp('slow', function() { self.removeItem(this.state.item.id) })
    });
  },

  componentWillUnmount: function() {
    $(this.formElement()).off('ajax:success.ChecklistItem').off('ajax:error.ChecklistItem')
    $(this.removeLink()).off('ajax:success.ChecklistItem')
  },

  getInitialState: function() {
    return { formName: this.props.item.name, item: this.props.item };
  },

  handleFormChange: function(e) {
    this.setState({ formName: e.target.value });
  },

  newRecord: function() { return !this.state.item.id; },

  currentlyInEditMode: function() {
    return this.newRecord() || this.props.editModeIdx === this.props.idx;
  },

  handleRowClick: function(e) {
    if(!$(e.target).is('input, a')) {
      this.toggleEditMode();
    }
  },

  toggleEditMode: function() {
    this.props.updateEditModeIdx(this.currentlyInEditMode() ? -1 : this.props.idx);
  },

  render: function() {
    var name = '';
    var placeholder = '';
    var formClass = 'edit_checklist_item';
    var removeLink = '';
    var method = "patch";
    var formAttrs = {
      'method': "post",
      'data-remote': "true",
      'action': this.state.item.path,
      'className': formClass,
      'acceptCharset': "UTF-8"
    }

    if (this.currentlyInEditMode()) {
      formAttrs['data-edit-mode'] = "true"
    }

    if (!this.newRecord()) {
      var name = (
        <div className="checklist-item-name" data-edit-prompt="Edit">
          <span className="name">{this.state.item.name}</span>
        </div>
      );

      var removeLink = <a ref="removeLink" href={this.state.item.path} className="destroy-checklist-item btn btn-danger btn-sm" data-method="delete" data-remote="true" data-disable="true" data-comfortable-text="Remove" data-abbreviated-text="X"></a>;
    } else {
      placeholder = 'New Item';
      formClass = 'new_checklist_item';
      method = "post";
    }

    return (
      <div className="row" onClick={this.handleRowClick} ref="row">
        <form {...formAttrs} ref="form">
          <div className="col-xs-6 col-md-4">
            {name}
            <input name="utf8" type="hidden" value="✓" />
            <input type="hidden" name="_method" value={method} />
            <input className='form-control' type="text" name="checklist_item[name]" id="checklist_item_name" placeholder={placeholder} value={this.state.formName} data-edit-control="true" onChange={this.handleFormChange} />
          </div>
          <div className="col-xs-2 col-md-1">
            <input type="submit" value="Save" data-disable-with="Saving.." className="btn btn-primary btn-sm" data-edit-control="true" />
          </div>
        </form>
        <div className="col-xs-2 col-md-5">
          {removeLink}
        </div>
      </div>
    );
  }
})
