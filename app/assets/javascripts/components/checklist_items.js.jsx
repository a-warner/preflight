window.ChecklistItems = React.createClass({
  getInitialState: function() {
    return { editModeIdx: -1, items: this.props.items };
  },

  updateEditModeIdx: function(newIdx) {
    this.setState({ editModeIdx: newIdx })
  },

  addChecklistItem: function(newItem) {
    var newItems = this.state.items.slice(0);
    newItems.splice(this.state.items.length - 1, 0, newItem);

    this.setState({ items: newItems });
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
            return <ChecklistItem key={item.id} idx={idx} item={item} updateEditModeIdx={self.updateEditModeIdx} editModeIdx={self.state.editModeIdx} addChecklistItem={self.addChecklistItem} />;
          })
        }
      </div>
    );
  }
})
