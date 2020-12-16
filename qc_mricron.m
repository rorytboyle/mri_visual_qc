% Function loops through .nii files, displays each file individually in
% mricron and stores a user rating of image quality.
%
% files must be a cell array of .nii filenames (with full pathnames) or else
% a folder containing only .nii files
% 
% Users can then quickly scroll through the loaded image in mricron.
% After each image is displayed in mricron, the loop does not continue
% until the user responds with 0,1,2 to indicate image quality/usability.
%
% Users must respond 0 to indicate the image is unusable (i.e. has
% artefacts), 1 to indicate they are unsure about whether it is usable or
% not, and 2 to indicate the image is usable.
%
% When user types end, it saves a .mat file to current directory
% containing: qc_array (filenames and ratings (Bad/Unsure/Good)), score
% (numerical rating values), and last_file_rated (name of the last file
% rated)

function [qc_array, score] = qc_mricron(files)

% read in mricron location
if ispc
    mricron_loc = which('mricron.exe');
else
    mricron_loc = input('\n Please enter the full file path (and filename) of the mricron application: ', 's');
end

% if files is a cell array of images, verify images are .nii and verify
% they can be loaded by mricron
if iscell(files) == 1
    ismember(files(1), '.nii');
    files_str = char(files(1));
    if strcmp(files_str(end-3:end), '.nii') == 0 % if files don't end in .nii stop function
        fprintf('You have loaded in non .nii files or your cell array of files does not contain any .nii files.\nPlease call function again and load in only .nii files\n')
        return 
    % check if filenames contain a valid file path 
    elseif isfolder(files_str(1:max(strfind(files_str, filesep))-1)) == 0
        fprintf('Your filenames do not contain a valid filepath. \nPlease call function again and load in files with a valid path within their name. \nAlternatively, load in a folder containing only T1 images\n')
        return
    end
end

% read in filenames from a directory, if files = a cell array of image names,
% then skip and proceed 
if iscell(files) == 0
    file_struct  = dir(files); % read in files
    file_struct = file_struct(3:end); % remove first two rows in struct ("." and "..")
    clear files
    files = cell(length(file_struct),1);
    for i = 1:length(file_struct)
        files{i} = [char(file_struct(i).folder) filesep char(file_struct(i).name)];
        files_str = char(files(i));
    end
    if strcmp(files_str(end-3:end), '.nii') == 0
        fprintf('\nYour folder contains non .nii files. Please load in a folder containing only .nii files.\n') %%% CURRENTLY NOT WORKING PROPERLY
        return
    end
end

% Initialise arrays
qc_array = cell(size(files));
score = zeros(size(files));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Begin loop
user_ends = 0; % variable to break out of while loop
for i=1:length(files)
    
    qc_array(i,1) = files(i);
    % open up mricron
   loaded_im = dos([mricron_loc ' ' files{i} ' ' '&']);
   if loaded_im == 1
       fprintf('ERROR LOADING IMAGE IN MRICRON\n')
       break
   end
   %%% get qc rating --> 0 = bad, 1 = unsure, 2 = good
   %%% add user input to array with filename = 1 column and orientation
   %%% judgement = other column
   %%% don't proceed with loop until user input is stored

   while user_ends == 0
        x = input('\n To end program & save info, type end \n Rate image. Enter 0 for bad, Enter 1 for unsure, Enter 2 for good: ', 's');
       % if image is bad (0) --> add 'Bad' to cell array and 0 to score array
        if strcmp(x, '0')
           qc_array(i, 2) = {'Bad'};
           score(i) = 0;
           last_file_rated = files(i);
           save('qc_info', 'qc_array', 'score', 'last_file_rated');
           break
       % if user is unsure about image (0) --> add 'Unsure' to cell array and 1
       % to score array
        elseif strcmp(x, '1')
           qc_array(i, 2) = {'Unsure'};
           score(i) = 1;
           last_file_rated = files(i);
           save('qc_info', 'qc_array', 'score', 'last_file_rated');
           break
       % if image is good (2) --> add 'Good' to cell array and 2 to score array
        elseif strcmp(x, '2')
           qc_array(i, 2) = {'Good'};
           score(i) = 2;
           last_file_rated = files(i);
           save('qc_info', 'qc_array', 'score', 'last_file_rated');
           break
       % else request input again
        elseif strcmp(x, 'end') == 0
           fprintf('\n Invalid input - Please enter a number between 0-2\n');
        elseif strcmp(x, 'end')
            %%% return qc_array and score for all files up until i
           qc_array = qc_array(1:i-1, :);
           score = score(1:i-1);
           if i>1
               last_file_rated = files(i-1);
           end
           user_ends = 1;
           break
       break
       end
   end
   if user_ends == 1
       break
   end
   % close mricron on windows pc
   if ispc==1
       [~, ~] = dos('taskkill /F /IM mricron.exe /IM cmd.exe');
   else
       fprintf('\n ***** Close MRIcron after each image! *****\n \n') % ADD command to close program on unix/mac os once found here
   end
end

% save variables to qc_info.mat in current directory
if user_ends == 0 
    save('qc_info', 'qc_array', 'score');
elseif user_ends == 1 && i > 1
    save('qc_info', 'qc_array', 'score', 'last_file_rated');
end

