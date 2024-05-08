
# Here EGB349 bash.rc tools nice to have in every new terminal

source /opt/ros/noetic/setup.bash # Sorce ros code, so the terminal knows where ROS is installed
catkin_ws_name="catkin_ws"   # Name of the worspace, used as a variable later as ${catkin_ws_name}

source ~/${catkin_ws_name}/devel/setup.bash    # Load the packages in the workspace, so the terminal session is aware of them and can find them with double tab. tab tab is the friend of your memory!

# disros definition so we dont need to worrie about ros ip manual setting. 
disros() {
  # Setup for distributed ROS
  export ROS_IP="$(hostname -I | cut -d' ' -f1)"
  #echo "Identifying as: $ROS_IP"
 
  if [ "$#" -eq 1 ]
  then
    export ROS_MASTER_URI="http://$1:11311"
    echo "Connecting to: $ROS_MASTER_URI"
  fi
}
 
# We run disros so each terminal knows by default it is on the master, (we can add the ip of the master if we are running this from GCS: disros 192.zzz.abc.123 )
disros

# Activate multiple terminals using the powerfull tmux, so a single terminal can do marbels!
# There is a safety feature build-in that cause a "file not foud" error on the control.lauch, check the path (missing ~ at start), this file will connect UAV and Onboard computer, so be carefull. 
function run349 (){
    echo "Starting Tmux session for EGB349 UAV control"
    sleep 2
    tmux new-session -s cdrone\; set -g mouse on\; send-keys "roscore" C-m\; split-window -h -p 85\; select-pane -t 0\; split-window -v\;                   \
        send-keys "htop" C-m\; select-pane -t 2\; split-window -h\; select-pane -t 2\;                   \
        send-keys "ls -l" C-m\; split-window -v -p 75\;               \
        send-keys "sleep 5; roslaunch /${catkin_ws_name}/launch/control.launch" C-m\; split-window -v -p 60\;                                 \
        send-keys "sleep 10; roslaunch qutas_lab_450 environment.launch" C-m\; split-window -v \;                                        \
        send-keys "sleep 10; Vision code here... C-m" \;  select-pane -t 6\;                                   \
        send-keys "rosbag -a" \;  split-window -v -p 85\;                      \
        send-keys "rostopic echo /mavros/local_position/pose" C-m\; split-window -v -p 80\; select-pane -t 7\; split-window -h\; \
        send-keys "rostopic echo /mavros/vision_position/pose" C-m\; select-pane -t 9\;                                                 \
        send-keys "" \; split-window -v -p 10\;                             \
        send-keys "tmux kill-session" \;
}
export -f run349
