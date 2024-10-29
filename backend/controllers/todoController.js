import { Todo } from "../models/Todo.js";

export const CreateTodo = async (req, res) => {
  try {
    const { title, description, deadline, image } = req.body;
    const todo = new Todo({
      userId: req.user.id,
      title,
      description,
      deadline,
      image,
    });
    const results = await todo.save();
    if (!results) {
      return res.status(404).send({ message: "Todo creation failed" });
    }
    return res.status(201).json(todo);
  } catch (error) {
    res
      .status(500)
      .json({ message: "Error creating todo", error: error.message });
  }
};

export const GetTodos = async (req, res) => {
  console.log('FilterTodos function triggered');
  try {
    // const { filterType = "all" } = req.query;
    const { filter } = req.query;
    
    let query = { userId: req.user.id };
    let todos;
    switch (filter) {
      case "time":
        todos = await Todo.find(query).sort({ createdAt: 1 }); // latest first
        break;
      case "deadline":
        todos = await Todo.find({ ...query, deadline: { $ne: null } }).sort({
          deadline: -1,
        });
        break;
      case "all":
        todos = await Todo.find(query);
        break;
    }
    if (!todos) return res.status(404).json({ message: "Todos not found" });
    return res.status(200).json(todos);
  } catch (error) {
    res.status(500).json({ message: "Error filtering todos", error });
  }
};


// export const GetTodos = async (req, res) => {
//   console.log('Get todos function triggered');
//   try {
//     const todos = await Todo.find({ userId: req.user.id });
//     if (!todos) {
//       res
//         .status(400)
//         .send({ message: `Cannot find Todos for User : ${req.user.id}` });
//     }
//     return res.status(200).json(todos);
//   } catch (error) {
//     res.status(500).json({ message: "Error fetching todos", error });
//   }
// };

// Get a specific to-do by ID
export const GetTodoById = async (req, res) => {
  try {
    const todo = await Todo.findOne({
      _id: req.params.id,
      userId: req.user.id,
    });
    if (!todo) return res.status(404).json({ message: "Todo not found" });
    return res.status(200).json(todo);
  } catch (error) {
    res.status(500).json({ message: "Error fetching todo", error });
  }
};

// Update a to-do
export const UpdateTodo = async (req, res) => {
  try {
    const { title, description, deadline, image } = req.body;
    const todo = await Todo.findOneAndUpdate(
      { _id: req.params.id, userId: req.user.id },
      { title, description, deadline, image },
      { new: true }
    );
    if (!todo) return res.status(404).json({ message: "Todo not found" });
    console.log("updated");
    return res.status(200).json(todo);
  } catch (error) {
    res.status(500).json({ message: "Error updating todo", error });
  }
};

// Delete a to-do
export const DeleteTodo = async (req, res) => {
  try {
    const todo = await Todo.findOneAndDelete({
      _id: req.params.id,
      userId: req.user.id,
    });
    if (!todo) return res.status(404).json({ message: "Todo not found" });
    res.json({ message: "Todo deleted" });
  } catch (error) {
    res.status(500).json({ message: "Error deleting todo", error });
  }
};

