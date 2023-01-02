#!/bin/bash

#VARIABLES ###############
min_folder_size=3
singles_folder_name="singles"
#########################

declare -A grouped_images

for image in $(ls -tr *.JPG *.jpg *.NEF *.nef); do
	create_date=$(stat -c %.10y $image)
	#echo $image, $create_date
	((grouped_images[$create_date]++))

done
for group in "${!grouped_images[@]}"; do
	if [[ ${grouped_images[$group]} -le min_folder_size ]];
		 
	then
		((grouped_images[singles]+=${grouped_images[$group]}))
		unset grouped_images[$group]
	fi
done
echo "folder_name - n_of_images"
for group in "${!grouped_images[@]}"; do
	echo "$group - ${grouped_images[$group]}"
	done
read -p "This will create ${#grouped_images[@]} folders plus singles folder with ${grouped_images[singles]} images inside" -n 1
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
for image in $(ls -tr *.JPG *.NEF); do
	create_date=$(stat -c %.10y $image)
	if [ ${grouped_images[$create_date]+_} ]; then
		mkdir -p $create_date
		cp -v $image $create_date
	else
		mkdir -p $singles_folder_name
		cp -v $image $singles_folder_name
	fi

done
fi

