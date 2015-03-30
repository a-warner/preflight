window.ChecklistItems = React.createClass({
  getInitialState: function() {
    return { editModeIdx: -1 };
  },

  updateEditModeIdx: function(newIdx) {
    this.setState({ editModeIdx: newIdx })
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
          this.props.items.map(function(item, idx) {
            return <ChecklistItem key={item.key} idx={idx} item={item} updateEditModeIdx={self.updateEditModeIdx} editModeIdx={self.state.editModeIdx} />;
          })
        }
      </div>
    );
  }
})
