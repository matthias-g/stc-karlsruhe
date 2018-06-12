/*
 * Expects parameters:
 *  <string> model_type: snake_case, pluralized name of the model owning the association
 *  <int> model_id: id of the record with the association
 *  <string> relationship: name of the association to be changed
 *  <string> item_type: snake_case, pluralized name of the model stored in the association
 *  [{<string> name, <int> id}] items: all items currently being associated
 *  [{<string> name, <int> id, <string> tokens}] pool: all possible items for the select
 */
class RelationshipList extends React.Component {

    constructor(props) {
        super(props);
        this.state = {items: props.items};
        this.set_add_select = (element) => this.add_select = element;
    }

    render() {
        var items = this.state.items.map((item, idx, arr) => this.renderItem(item, idx === (arr.length - 1)));
        return (
            <div>
                <div>{items}</div>
                {this.renderAddLink()}
            </div>
        )
    }

    renderItem(item, isLast) {
        var title = I18n.t(window.singularize(this.props.model_type)
            + '.button.removeFrom' + window.capitalize(this.props.relationship));
        var deleteMessage = I18n.t('general.message.confirmRemoveLong', {subject: item.name});
        return (
            <span key={"list" + item.id} className="item">
                {item.name}
                <a className="remove-link" href = "#" title = { title } data-confirm = { deleteMessage }
                   onClick = {(e) => {e.preventDefault(); this.removeItem(item.id, e)}} >
                    <span className="fas fa-times"></span>
                </a>
                {isLast ? '' : ','}
            </span>
        );
    }

    renderAddLink() {
        var options = this.props.pool.map((opt) => {
            return <option key={"opt" + opt.id} value={opt.id} data-tokens={opt.tokens}>{opt.name}</option>
        });
        return (
            <select ref = { this.set_add_select }
                name = "add-action-leader"
                id = "add-action-leader"
                className = "col-select"
                data-live-search = "true"
                data-size = "5"
                data-type = "jsonapi">{options}
            </select>
        )
    }

    addItem(id) {
        apiAdd(this.props.model_type, this.props.model_id,
            this.props.relationship, this.props.item_type, id).done(() => {
            var name = find_in_object_array(id, this.props.pool).name,
                items = this.state.items.slice();
            items.push({name: name, id: id});
            this.setState({items: items});
        });
    }

    removeItem(id) {
        apiRemove(this.props.model_type, this.props.model_id,
                  this.props.relationship, this.props.item_type, id).done(() => {
            var items = this.state.items.slice().filter((item) => (item.id !== id));
            this.setState({items: items});
        });
    }

    componentDidMount() {
        this.loadSelectPicker();
    }

    componentDidUpdate() {
        this.loadSelectPicker();
    }

    loadSelectPicker() {
        var select = $(this.add_select);
        select.selectpicker('render');
        select.off('changed.bs.select');
        select.on('changed.bs.select', () => this.addItem(parseInt(this.add_select.value)));
    }
}