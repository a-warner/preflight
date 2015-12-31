window.ChecklistItems = React.createClass({
  getInitialState: function() {
    return { editModeIdx: -1, items: this.props.items };
  },

  updateEditModeIdx: function(newIdx) {
    this.setState({ editModeIdx: newIdx })
  },

  addChecklistItem: function(newItem) {
    var newItems = this.state.items.slice(0);
    newItems.push(newItem);
    this.setState({ items: newItems, newItemFormName: '' });
  },

  removeItem: function(itemId) {
    this.setState({items: items.filter(function(i) { return i.id !== itemId }) });
  },

  render: function() {
    var self = this;
    return (
      <div className="checklist-items">
        <div className="row">
          <div className="col-xs-10">
            <h4>Item</h4>
          </div>
        </div>
        {
          this.state.items.map(function(item, idx) {
            return <ChecklistItem key={item.id} idx={idx} item={item} updateEditModeIdx={self.updateEditModeIdx} editModeIdx={self.state.editModeIdx} addChecklistItem={self.addChecklistItem} removeItem={self.removeItem} />;
          })
        }
        <div className="row">
          <ChecklistItemForm placeholder="New Item" method="post" item={{name: this.state.newItemFormName, path: this.props.checklist.create_item_path}} editMode={true} formClass="new_checklist_item" formAjaxSuccess={this.addChecklistItem} />
        </div>
      </div>
    );
  }
})
