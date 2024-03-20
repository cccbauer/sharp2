#!/bin/sh

this_step=$1
echo 'this step:' $this_step
if [[ -z $this_step ]];
then
	input_string=$(zenity --forms --title="MURFI GUI" \
	--separator=" " \
	--add-entry="Participant ID (####)" \
	--add-combo="Step" --combo-values "new_subject|setup_localizer|setup_feedback" \
	--cancel-label "Exit" --ok-label "Run Selected Step")
	ret=$?

	# parse zenity output using space as delimiter
	read -a input_array <<< $input_string
	partcipant_id=sharp2-${input_array[0]}
	step=${input_array[1]}
	
elif [[ $this_step == 'setup_localizer' ]];
then
	input_string=$(zenity --forms --title="MURFI LOCALIZER GUI" \
	--text="PARTICIPANT NAME: ${MURFI_SUBJECT_NAME}" \
	--separator=" " \
	--add-combo="Step" --combo-values "setup_localizer|2vol|2min_resting_state|extract_rs_networks|process_roi_masks|register|experience_sampling|cleanup|backup_reg_mni_masks_to_2vol" \
	--cancel-label "Exit" --ok-label "Run Selected Step")
	ret=$?
	# parse zenity output using space as delimiter
	read -a input_array <<< $input_string
	step='step_localizer'
	step_localizer=${input_array[0]}
	partcipant_id=$MURFI_SUBJECT_NAME
	
elif [[ $this_step == 'setup_feedback' ]];
then
	input_string=$(zenity --forms --title="MURFI FEEDBACK GUI" \
	--text="PARTICIPANT NAME: ${MURFI_SUBJECT_NAME}" \
	--separator=" " \
	--add-combo="Step" --combo-values "setup_feedback|2vol|resting_state|extract_rs_networks|process_roi_masks|register|experience_sampling|feedback|cleanup|backup_reg_mni_masks_to_2vol" \
	--cancel-label "Exit" --ok-label "Run Selected Step")
	ret=$?
	# parse zenity output using space as delimiter
	read -a input_array <<< $input_string
	step=${input_array[0]}
	partcipant_id=$MURFI_SUBJECT_NAME
fi

# If user selects the Exit button, then quit MURFI
if [[ $ret == 1 ]];
then
	exit 0
fi


# Run selected step
if [ ${step} == 'new_subject' ]
then
	echo "[$(date +%F_%T)] source createxml.sh ${partcipant_id} setup" >> "../subjects/${partcipant_id}/murfi_command_log.txt"
	source createxml.sh ${partcipant_id} setup 

elif [ ${step} == 'setup_localizer' ]
then
	echo "[$(date +%F_%T)] source localizer_smhc.sh ${partcipant_id} ${step}" >> "../subjects/${partcipant_id}/murfi_command_log.txt"
	${step} == 'setup_localizer'
	echo ${step}
	source localizer_smhc.sh ${partcipant_id} ${step}
	
elif [ ${step_localizer} ]
then
	echo "[$(date +%F_%T)] source localizer_smhc.sh ${partcipant_id} ${step_localizer}" >> "../subjects/${partcipant_id}/murfi_command_log.txt"
	step == 'setup_localizer'
	echo 'this local step' ${step}
	
	source localizer_smhc.sh ${partcipant_id} ${step_localizer}	

elif [ ${step} == 'setup_feedback' ]
then
	echo "[$(date +%F_%T)] source feedback.sh ${partcipant_id} ${step}" >> "../subjects/${partcipant_id}/murfi_command_log.txt"
    ${step} == 'setup_feedback' 
	source feedback_smhc.sh ${partcipant_id} ${step}
	
elif [ ${step_feedback} ]
then
	echo "[$(date +%F_%T)] source feedback.sh ${partcipant_id} ${step_feedback}" >> "../subjects/${partcipant_id}/murfi_command_log.txt"
    ${step} == 'setup_feedback' 
	source feedback_smhc.sh ${partcipant_id} ${step_feedback}	

fi

# Re-launch script to keep MURFI GUI open echo ${step}
echo 'step' ${step}
bash launch_murfi_smhc.sh ${step}
