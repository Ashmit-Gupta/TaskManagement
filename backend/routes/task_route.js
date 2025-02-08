const express = require('express');
const mongoose = require('mongoose');
const jwt = require("jsonwebtoken");
const Task = require('../models/task_model');
const authMiddleware = require('../middlewares/auth_middleware');
const taskRouter = express.Router();

//CREATE A Task
taskRouter.post('/api/tasks' , authMiddleware , async(req,res)=>{


    try{
        //add the priority 
        const {dueDate,description,priority} = req.body;
        
        const task = await Task.create({
            userId:req.id,
            dueDate,
            description,
            priority ,
        });
        res.status(200).json({
            message:"Task created successfully",
            task
        });


    }catch(error){
        console.error(error.message);

        if (error instanceof mongoose.Error.ValidationError) {
            return res.status(400).json({ message: 'Validation Error', errors: error.errors });
        }
        return res.status(500).json({
            message:error.message
        });
    }
});

//READ ALL THE Task adn send the task in order 
taskRouter.get('/api/tasks' , authMiddleware , async(req,res)=>{
    try{
        const task = await Task.find({
            userId:req.id,
        });
    
        return res.status(200).json({
            task
        })

    }catch(error){
        console.error(error.message);

        if (error instanceof mongoose.Error.ValidationError) {
            return res.status(400).json({ message: 'Validation Error', errors: error.errors });
        }
        
        return res.status(500).json({
            message:error.message
        });
    }
});


//UPDATING A task
taskRouter.patch('/api/tasks/:id' , authMiddleware , async(req,res)=>{
    try{
        const {id} = req.params;
        const updatedTask = await Task.findByIdAndUpdate(id,req.body,{new:true});
        
        if(!updatedTask){
            return res.status(404).json({ message: "Task not found" });
        }
            return res.json({
                message:"Todo updated Successfully",
                updatedTask
            })

    }catch(error){
        console.error(error.message);

        if (error instanceof mongoose.Error.ValidationError) {
            return res.status(400).json({ message: 'Validation Error', errors: error.errors });
        }
        
        return res.status(500).json({
            message:error.message
        });
    }
});


taskRouter.delete('/api/tasks/:id', authMiddleware,async (req,res) => {
    try {
        await Task.findByIdAndDelete(req.params.id);
        res.json({ message: "Task deleted successfully" });

    } catch (error) {
        console.error(error.message);
        res.status(500).json({ message: error.message });
    }
}); 
module.exports = taskRouter;