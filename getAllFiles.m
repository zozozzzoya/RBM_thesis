% endgoal - MasterMatrix (MM) of number of object quotation awerall through images:
% n rows, m columns 

%step 1 - get only unique words by running through all XMLs and adding them
%to the single array

%get filenames ready and accounted for
%also to keep the data folder separate insert the dir access from the
%classifier


cd DATA;
infiles = dir('*.xml');
m = size(infiles, 1);

% then run it again while tiyng to the infiles{j, 1} the cell array with
% object names and their coordinates? do it in a separate script?

arrayUniqueWords = [];

for ss=1:m
    xmlFile = infiles(ss).name;
    xDoc = xmlread(xmlFile);
    annotationNode = xDoc.getDocumentElement;
    entries = annotationNode.getChildNodes;

for k=0:entries.getLength - 1
   
    if strcmpi(entries.item(k).getNodeName, 'object')
        object = entries.item(k).getFirstChild;
        
        while ~isempty(object)
            if strcmpi(object.getNodeName, 'name')
                objectName = object.getTextContent;  
                arrayUniqueWords{end+1} = char(objectName);
                break;
            else
                object = object.getNextSibling;
            end
            
        end
        
    end
    
end

end

%get the array of unique objects
onlyUniqueWords = unique(arrayUniqueWords);

%get the number of rows in the MM
n = size(onlyUniqueWords, 2);

%step 2 - fill the MM(n, m) with number of each words in each image with the
%double loop - amount of word(i) in a file(j) stored in MM{i, j}

masterMatrix = zeros(n,m);

%fileArrayObjImg = [];

for j=1:m
    for i=1:n
        
       xmlFile = infiles(j).name; 
       xDoc = xmlread(xmlFile);
       annotationNode = xDoc.getDocumentElement;
       entries = annotationNode.getChildNodes;
       
       for k=0:entries.getLength - 1
           
           if strcmpi(entries.item(k).getNodeName, 'object')
               object = entries.item(k).getFirstChild;
               
                while ~isempty(object)
                    if strcmpi(object.getNodeName, 'name')
                        objectName = object.getTextContent;  
                        %fileArrayObjImg{end+1} = char(objectName);
                        
                        if strcmpi(objectName, onlyUniqueWords(i))
                            masterMatrix(i, j) = masterMatrix(i, j) + 1;
                        end  
                            
                        break;
                    else
                        object = object.getNextSibling;
                    end
                end
                
           end
           
       end
       
    end
    
end

%ASSIGN LABELS TO THE MM

%colNames = {infiles(:).name};
%here run a loop to relpace '*.xml' filenames with '*'
%rowNames = onlyUniqueWords;
%masterMatrixLabeled = array2table(masterMatrix, 'RowNames', onlyUniqueWords, 'VariableNames', columnNames)


% fileArrayObjImg{end+1} = char(objectName);
