window.ChecklistItemForm = React.createClass({
  formElement: function() { return React.findDOMNode(this.refs.form); },

  componentDidMount: function() {
    var self = this;

    $(this.formElement()).on('ajax:success.ChecklistItem', function(e, newItem) {
      self.props.formAjaxSuccess(newItem)
    }).on('ajax:error.ChecklistItem', function(e, xhr) {
      alert(xhr.responseText)
    });
  },

  componentWillUnmount: function() {
    $(this.formElement()).off('ajax:success.ChecklistItem').off('ajax:error.ChecklistItem')
  },

  getInitialState: function() {
    return { formName: this.props.item.name }
  },

  componentWillReceiveProps: function(newProps) {
    this.setState({ formName: newProps.item.name })
  },

  handleFormChange: function(e) {
    this.setState({ formName: e.target.value });
  },

  render: function() {
    var formAttrs = {
      'method': "post",
      'data-remote': "true",
      'action': this.props.item.path,
      'className': this.props.formClass,
      'acceptCharset': "UTF-8"
    }

    if (this.props.editMode) {
      formAttrs['data-edit-mode'] = "true"
    }

    return (
      <form {...formAttrs} ref="form">
        <div className="col-xs-6 col-md-4">
          {this.props.name}
          <input name="utf8" type="hidden" value="✓" />
          <input type="hidden" name="_method" value={this.props.method} />
          <input className='form-control' type="text" name="checklist_item[name]" id="checklist_item_name" placeholder={this.props.placeholder} value={this.state.formName} data-edit-control="true" onChange={this.handleFormChange} />
        </div>
        <div className="col-xs-2 col-md-1">
          <input type="submit" value="Save" data-disable-with="Saving.." className="btn btn-primary btn-sm" data-edit-control="true" />
        </div>
      </form>
    );
  }
})
