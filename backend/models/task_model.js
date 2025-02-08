
const mongoose = require('mongoose');
const Schema = mongoose.Schema;
const ObjectId = mongoose.ObjectId;

const taskSchema = new Schema({
    userId:{
        required:true,
        type:ObjectId,
        ref:"User"
    },
    dueDate:{
        type:Date,
        required:true
    } ,
    done:{
        type:Boolean,
        default:false,
    },
    description:{
        type:String,
        required:true
    },
    priority:{
        type:String,
        enum:['low','medium','high'],
        default:'low',
    }
    },    
    {
        timestamps:true
    })

    
taskSchema.pre('save', function (next) {
    if (this.dueDate < this.createdAt) {
        return next(new Error("Due date can't be before the creation date"));
    }
    next();
});
    

const Task = mongoose.model('Task',taskSchema);

module.exports = Task;
