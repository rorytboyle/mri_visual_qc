# mri_visual_qc
Code for quick visual inspection of structural MRIs using mricron

User must have mricron installed http://people.cas.sc.edu/rorden/mricron/install.html 

It allows a user to loop through a set of MRI files and have a quick visual inspection of the MRI in MRIcron, and then assign a rating (i.e. 0 = Bad image, 1 = Unsure, 2 = Good image).  These ratings are then stored in a mat file alongside the image name.

The user can use these ratings to remove any images with artefacts.

# Notes
This function only works for Windows - it uses dos commands to open and close MRIcron in each loop
