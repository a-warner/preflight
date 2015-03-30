window.ChecklistItem = React.createClass({
  removeLink: function() { return React.findDOMNode(this.refs.removeLink); },
  row: function() { return React.findDOMNode(this.refs.row); },

  componentDidMount: function() {
    var self = this;

    $(this.removeLink()).on('ajax:success.ChecklistItem', function() {
      $(self.row()).slideUp('slow', function() { self.removeItem(this.state.item.id) })
    });
  },

  componentWillUnmount: function() {
    $(this.removeLink()).off('ajax:success.ChecklistItem')
  },

  formAjaxSuccess: function(newItem) {
    if (this.newRecord()) {
      this.props.addChecklistItem(newItem);
      this.refs.form.setState({formName: this.props.item.name});
    } else {
      this.toggleEditMode();
      this.setState({item: newItem});
    }
  },

  getInitialState: function() {
    return { item: this.props.item };
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
        <ChecklistItemForm ref="form" placeholder={placeholder} name={name} method={method} item={this.state.item} editMode={this.currentlyInEditMode()} formClass={formClass} formAjaxSuccess={this.formAjaxSuccess} />
        <div className="col-xs-2 col-md-5">
          {removeLink}
        </div>
      </div>
    );
  }
})
