window.ChecklistItem = React.createClass({
  getInitialState: function() {
    return { formName: this.props.name, name: this.props.name };
  },

  handleFormChange: function(e) {
    this.setState({ formName: e.target.value })
  },

  render: function() {
    var name = '';
    var placeholder = '';
    var formClass = 'edit_checklist_item';
    var removeLink = '';
    var method = "patch";

    if (this.props.id) {
      var name = (
        <div className="checklist-item-name" data-edit-prompt="Edit">
          <span className="name">{this.state.name}</span>
        </div>
      );

      var removeLink = <a href={this.props.path} className="destroy-checklist-item btn btn-danger btn-sm" data-method="delete" data-remote="true" data-disable="true" data-comfortable-text="Remove" data-abbreviated-text="X"></a>;
    } else {
      placeholder = 'New Item';
      formClass = 'new_checklist_item';
      method = "post";
    }

    return (
      <div className="row">
        <form method="post" data-remote="true" action={this.props.path} className={formClass} accept-charset="UTF-8">
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
