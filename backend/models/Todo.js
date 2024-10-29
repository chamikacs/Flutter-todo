import mongoose from "mongoose";

const todoSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    title: {
      type: String,
      required: true,
    },
    description: {
      type: String,
      required: true,
    },
    deadline: {
      type: Date,
      required: false,
    },
    image: {
      type: String,
      required: false,
    },
  },
  { timestamps: true }
);

export const Todo = mongoose.model("Todo", todoSchema);
