window.ChecklistItems = React.createClass({
  render: function() {
    return (
      <div className="checklist-items">
        <div className="row">
          <div className="col-xs-10">
            <h4>Item</h4>
          </div>
        </div>
        {
          this.props.items.map(function(item) {
            return <ChecklistItem {...item} />
          })
        }
      </div>
    );
  }
})
