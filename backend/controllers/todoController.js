import { Todo } from "../models/Todo.js";
import fs from "fs";

export const CreateTodo = async (req, res) => {
  try {
    const { title, description, deadline, image } = req.body;

    {
      /* Use this code only to save the image in the uploads folder */
    }
    // let imagePath = null;
    // if (image) {
    //   // Decode the base64 string and save it as an image file
    //   const buffer = Buffer.from(image, 'base64');
    //   const fileName = `${Date.now()}.png`;
    //   imagePath = `/uploads/${fileName}`;
    //   fs.writeFileSync(`./uploads/${fileName}`, buffer);
    // }

    const todo = new Todo({
      userId: req.user.id,
      title,
      description,
      deadline,
      image: image,
    });

    const result = await todo.save();
    return res.status(201).json(result);
  } catch (error) {
    res
      .status(500)
      .json({ message: "Error creating todo", error: error.message });
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

export const GetTodos = async (req, res) => {
  try {
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
