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
    this.toggleEditMode();
    this.setState({item: newItem});
  },

  getInitialState: function() {
    return { item: this.props.item };
  },

  currentlyInEditMode: function() {
    return this.props.editModeIdx === this.props.idx;
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
    var name = (
      <div className="checklist-item-name" data-edit-prompt="Edit">
        <span className="name">{this.state.item.name}</span>
      </div>
    );

    return (
      <div className="row" onClick={this.handleRowClick} ref="row">
        <ChecklistItemForm ref="form" name={name} method="patch" item={this.state.item} editMode={this.currentlyInEditMode()} formClass="edit_checklist_item" formAjaxSuccess={this.formAjaxSuccess} focus={this.currentlyInEditMode()} />
        <div className="col-xs-2 col-md-5">
          <a ref="removeLink" href={this.state.item.path} className="destroy-checklist-item btn btn-danger btn-sm" data-method="delete" data-remote="true" data-disable="true" data-comfortable-text="Remove" data-abbreviated-text="X"></a>
        </div>
      </div>
    );
  }
})
