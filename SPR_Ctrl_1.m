%{
Initialize Simulink Model
modelName is set to 'SphericalRobotControl'.
new_system(modelName) creates a new Simulink model with this name.
open_system(modelName) opens the newly created Simulink model.
%}
modelName = 'SphericalRobotControl';
new_system(modelName);
open_system(modelName);

%{
Add Subsystem for Motor Control
Adds a MotorControl subsystem to the model.
Inside this subsystem, it adds a PID Controller block to control the motors.
The PID parameters (P, I, and D) are set to 1, 0.1, and 0.01 respectively. These are placeholders and should be tuned as needed.
%}
add_block('simulink/Commonly Used Blocks/Subsystem', [modelName '/MotorControl']);
add_block('simulink/Continuous/PID Controller', [modelName '/MotorControl/PID']);
set_param([modelName '/MotorControl/PID'], 'P', '1', 'I', '0.1', 'D', '0.01'); % Tune as necessary

%{
Add Subsystem for Sensor Feedback
Creates a Sensor Feedback subsystem that simulates sensor readings from an Encoder and a Gyroscope.
Both blocks are initialized with placeholder values (0), which should be replaced with the actual sensor logic or data.
%}
add_block('simulink/Commonly Used Blocks/Subsystem', [modelName '/SensorFeedback']);
add_block('simulink/Sources/Constant', [modelName '/SensorFeedback/Encoder']);
add_block('simulink/Sources/Constant', [modelName '/SensorFeedback/Gyroscope']);
% Set up Encoder and Gyroscope Blocks as needed
set_param([modelName '/SensorFeedback/Encoder'], 'Value', '0'); % Placeholder
set_param([modelName '/SensorFeedback/Gyroscope'], 'Value', '0'); % Placeholder

%{
Add Main Controller Block
A Main Controller subsystem is created. This controller processes sensor feedback to calculate control commands.
Inside the controller:
A Sum block is used to calculate the error between the Desired Trajectory and the feedback (likely the actual position).
The Desired Trajectory block holds the target position or velocity (currently set as a placeholder desired_trajectory).
%}
add_block('simulink/Commonly Used Blocks/Subsystem', [modelName '/MainController']);
add_block('simulink/Math Operations/Sum', [modelName '/MainController/ErrorCalculation']);
% Configure the Sum block to accept two inputs (one positive, one negative)
set_param([modelName '/MainController/ErrorCalculation'], 'Inputs', '|+-'); % Two inputs: one positive and one negative
add_block('simulink/Commonly Used Blocks/Constant', [modelName '/MainController/DesiredTrajectory']);
set_param([modelName '/MainController/DesiredTrajectory'], 'Value', 'desired_trajectory');

%{
Connect Main Controller to Motor Control and Sensor Feedback
This connects the output of the Main Controller to the input of the Motor Control subsystem.
It also connects the feedback from the Sensor Feedback subsystem to the Main Controller for error calculation.
%}
add_line(modelName, 'MainController/1', 'MotorControl/1');
add_line(modelName, 'SensorFeedback/1', 'MainController/2');

%{
Configure Outputs and Inputs
Two output blocks are added for monitoring:
Position: Displays the robot's position based on sensor feedback.
Velocity: Displays the robot's velocity based on sensor feedback.
The appropriate sensor feedback signals are connected to these outputs.
%}
add_block('simulink/Commonly Used Blocks/Out1', [modelName '/Position']);
add_block('simulink/Commonly Used Blocks/Out1', [modelName '/Velocity']);
add_line(modelName, 'SensorFeedback/1', 'Position/1');
add_line(modelName, 'SensorFeedback/2', 'Velocity/1');

%{
Save and open the model
Saves the current state of the Simulink model.
Reopens the model to display it in the Simulink interface.
A message is displayed indicating the model was created and opened successfully.
%}
save_system(modelName);
open_system(modelName);
disp(['Model ', modelName, ' created and opened.']);