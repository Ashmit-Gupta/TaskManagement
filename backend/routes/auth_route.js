const express = require('express');
const mongoose = require('mongoose');
const jwt = require("jsonwebtoken");
const UserModel = require('../models/user_model');
const authMiddleware = require('../middlewares/auth_middleware');
const {z} = require('zod');
const bcrypt = require('bcrypt');

const authRouter = express.Router();

const userSchema = z.object({
    name: z.string().min(1, "Name is required"),
    email: z.string().email("Invalid email").min(5),
    password: z.string().min(6, "Password must be at least 6 characters long"),
});

authRouter.get('/test', (req,res) =>{
    // console.log();
    res.json({
        message:"welcome to ashmits server"
    });
})

authRouter.post("/api/register", async(req, res)=>{
    try{
        
        const parseData = userSchema.safeParse(req.body);
        if(!parseData.success){
            return res.status(400).json({
                message:"Incorrect Format",
                error:parseData.error
            });
        }

        const {name , email, password} = req.body;
        const existingUser = await UserModel.findOne({
            email,
        })

        if (existingUser) {
            return res.status(409).json({ message: "User already exists. Please login." });
        }

        const hashedPassword = await bcrypt.hash(password,5);
        await UserModel.create({name,email,password:hashedPassword});
        res.status(200).json({
            message:"Registration Successful"
        });

    }catch(error){
        console.error("Error while sending " , error.message);
        res.status(400).json({
            message : error.message
        });
    }
});


authRouter.post('/api/login', async(req,res)=>{
    try{
        const {email, password} = req.body;

        const user = await UserModel.findOne({
            email,
        })

        if(!user || !(await bcrypt.compare(password,user.password))){
            return res.status(403).json({
                message:"Invalid Credentials"
            })
        }

        const token = jwt.sign({id:user._id},process.env.JWT_SECRET);

        res.status(200).json({
            name:user.name,
            email:user.email,
            token });

    }catch(error){
        console.error("Error while sending " , error.message);
        res.status(500).json({
            message : error.message
        });
    }
})

module.exports = authRouter;