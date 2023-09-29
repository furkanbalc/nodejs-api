const TodoModel = require('../models/todo.model');

class TodoService {
    static async createTodo(title,desc,priority) {
        const createTodo = new TodoModel({ title, desc, priority });
        return await createTodo.save();
    }
    static async getTodos(){
        const todoList = await TodoModel.find({})
        return todoList;
    }
    static async deleteTodo(id){
        const deleted = await TodoModel.findByIdAndRemove(id)
        return deleted;
    }
    static async updateTodo(id, title, desc, priority){
        const updated = await TodoModel.findByIdAndUpdate(id, { title, desc, priority }, { new: true });
        return updated;
    }
}
module.exports = TodoService;