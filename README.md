# mri_visual_qc
Code for quick visual inspection of structural MRIs using mricron

User must have mricron installed http://people.cas.sc.edu/rorden/mricron/install.html 

It allows a user to loop through a set of MRI files and have a quick visual inspection of the MRI in MRIcron, and then assign a rating (i.e. 0 = Bad image, 1 = Unsure, 2 = Good image).  These ratings are then stored in a mat file alongside the image name.

The user can use these ratings to remove any images with artefacts.

# Notes
This function has not been fully tested for errors yet and as such some errors may exist. However, it works fine if you load in a folder containing only .nii files.

This function currently only works for Windows as it uses dos commands to open and close MRIcron in each loop

I would welcome any feedback or suggestions and please let me know if you notice any errors/issues

# To-do list
1) Fully test for errors
2) Make function usable on mac & linux
3) Add optional arguments to:
        a) Write qc info to excel file
        b) Specify output folder
        c) Create new folder containing only usable and/or unsure images - could be memory intensive if a lot of files are qc'd
4) Specify location of mricron app on pc screen (may not be possible?)
5) Clean and tidy code
