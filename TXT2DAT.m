function varargout = TXT2DAT(varargin)
% TXT2DAT MATLAB code for TXT2DAT.fig
%      TXT2DAT, by itself, creates a new TXT2DAT or raises the existing
%      singleton*.
%
%      H = TXT2DAT returns the handle to a new TXT2DAT or the handle to
%      the existing singleton*.
%
%      TXT2DAT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TXT2DAT.M with the given input arguments.
%
%      TXT2DAT('Property','Value',...) creates a new TXT2DAT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TXT2DAT_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TXT2DAT_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TXT2DAT

% Last Modified by GUIDE v2.5 29-Jan-2019 12:05:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TXT2DAT_OpeningFcn, ...
                   'gui_OutputFcn',  @TXT2DAT_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before TXT2DAT is made visible.
function TXT2DAT_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TXT2DAT (see VARARGIN)

% Choose default command line output for TXT2DAT
handles.output = hObject;

% h = gcf;
% set(h,'toolbar','figure');
% set(h,'menubar','figure');

handles.fileID = [];
handles.data = [];
handles.electrodes = [];
set(handles.axes_hist,'Visible','off');
set(handles.title_hist,'Visible','off');
set(handles.thresh,'Visible','off');
set(handles.thresh_edit,'Visible','off');
set(handles.thresh_units,'Visible','off');
set(handles.pushbuttonRES2DINV,'Visible','off');
set(handles.pushbuttonRES3DINV,'Visible','off');
set(handles.pushbuttonAarhusInv,'Visible','off');
set(handles.pushbuttonCRTomo,'Visible','off');
set(handles.pushbuttonBERT,'Visible','off');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TXT2DAT wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TXT2DAT_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function txt_file_Callback(hObject, eventdata, handles)
% hObject    handle to txt_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.fileID = get(hObject,'String');

fid = fopen(handles.fileID);
c=textscan(fid,'%s','delimiter','\n');
fclose(fid);
tmp = c{1};
c = string(tmp);
indexHead = startsWith(string(c),'Time	MeasID');
indexEnd = startsWith(string(c),'--------');
headers = char(c(indexHead));
i = 1;
handles.index.IP = zeros(1,17).*NaN;
indexIP = startsWith(string(c),'- IP_WindowSecList:');
indexIP = find(indexIP==1,1,'first');
handles.IPWIN = str2num(extractAfter(char(c(indexIP)),'- IP_WindowSecList: '));
handles.IPSTR = num2str([length(handles.IPWIN)-1 handles.IPWIN]);
while ~isempty(headers),
    if contains(headers,'	'),
        Head{i} = extractBefore(headers,'	');
    else
        Head{i} = headers;
    end
    if strcmp(Head{i},'Var(%)'),
        handles.index.Var = i-1;% To account for the unread time
    elseif strcmp(Head{i},'Rho-a(Ohm-m)'),
        handles.index.rhoa = i-1;
    elseif strcmp(Head{i},'R(Ohm)'),
        handles.index.rho = i-1;
    elseif strcmp(Head{i},'A(x)'),
        handles.index.AxI = i-1;
    elseif strcmp(Head{i},'A(y)'),
        handles.index.AyI = i-1;
    elseif strcmp(Head{i},'A(z)'),
        handles.index.AzI = 1-1;
    elseif strcmp(Head{i},'A(adr)'),
        handles.index.AId = i-1;
    elseif strcmp(Head{i},'B(x)'),
        handles.index.BxI = i-1;
    elseif strcmp(Head{i},'B(y)'),
        handles.index.ByI = i-1;
    elseif strcmp(Head{i},'B(z)'),
        handles.index.BzI = i-1;
    elseif strcmp(Head{i},'B(adr)'),
        handles.index.BId = i-1;
    elseif strcmp(Head{i},'M(x)'),
        handles.index.MxI = i-1;
    elseif strcmp(Head{i},'M(y)'),
        handles.index.MyI = i-1;
    elseif strcmp(Head{i},'M(z)'),
        handles.index.MzI = i-1;
    elseif strcmp(Head{i},'M(adr)'),
        handles.index.MId = i-1;
    elseif strcmp(Head{i},'N(x)'),
        handles.index.NxI = i-1;
    elseif strcmp(Head{i},'N(y)'),
        handles.index.NyI = i-1;
    elseif strcmp(Head{i},'N(z)'),
        handles.index.NzI = i-1;
    elseif strcmp(Head{i},'N(adr)'),        
        handles.index.NId = i-1;
    else
        for j = 1 : 17,
            head_IP = sprintf('IP #%d(mV/V)',j);
            if strcmp(Head{i},head_IP)
                handles.index.IP(j) = i-1;
                break
            end
        end
    end            
    headers = erase(headers,Head{i});
    headers = strtrim(headers);
    i = i + 1;
end
i = i-2;
handles.data = dlmread(handles.fileID,'\t',[find(indexHead==1,1,'first'),1,find(indexEnd==1,1,'first')-3,i]);
handles.isIP = sum(~isnan(handles.index.IP)); 
if max(handles.data(:,handles.index.Var))>10,
    histogram(handles.axes_hist,handles.data(:,handles.index.Var),0:0.5:10);
else
    histogram(handles.axes_hist,handles.data(:,handles.index.Var));
end
xlabel('Error (%)');

% Finding the electrodes positions:
nb_data = size(handles.data,1);

set(handles.axes_hist,'Visible','on');
set(handles.title_hist,'Visible','on');
set(handles.thresh,'Visible','on');
set(handles.thresh_edit,'Visible','on');
set(handles.thresh_units,'Visible','on');
set(handles.pushbuttonRES2DINV,'Visible','on');
set(handles.pushbuttonRES3DINV,'Visible','on');
set(handles.pushbuttonAarhusInv,'Visible','on');
set(handles.pushbuttonCRTomo,'Visible','on');
set(handles.pushbuttonBERT,'Visible','on');

guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function txt_file_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in txt_file_push.
function txt_file_push_Callback(hObject, eventdata, handles)
% hObject    handle to txt_file_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[name, path] = uigetfile('*.txt');
handles.fileID = [path name];
set(handles.txt_file,'String',handles.fileID);

fid = fopen(handles.fileID);
c=textscan(fid,'%s','delimiter','\n');
fclose(fid);
tmp = c{1};
c = string(tmp);
indexHead = startsWith(string(c),'Time	MeasID');
indexEnd = startsWith(string(c),'--------');
headers = char(c(indexHead));
i = 1;
handles.index.IP = zeros(1,17).*NaN;
indexIP = startsWith(string(c),'- IP_WindowSecList:');
indexIP = find(indexIP==1,1,'first');
handles.IPWIN = str2num(extractAfter(char(c(indexIP)),'- IP_WindowSecList: '));
handles.IPSTR = num2str([length(handles.IPWIN)-1 handles.IPWIN]);
while ~isempty(headers),
    if contains(headers,'	'),
        Head{i} = extractBefore(headers,'	');
    else
        Head{i} = headers;
    end
    if strcmp(Head{i},'Var(%)'),
        handles.index.Var = i-1;% To account for the unread time
    elseif strcmp(Head{i},'Rho-a(Ohm-m)'),
        handles.index.rhoa = i-1;
    elseif strcmp(Head{i},'R(Ohm)'),
        handles.index.rho = i-1;
    elseif strcmp(Head{i},'A(x)'),
        handles.index.AxI = i-1;
    elseif strcmp(Head{i},'A(y)'),
        handles.index.AyI = i-1;
    elseif strcmp(Head{i},'A(z)'),
        handles.index.AzI = 1-1;
    elseif strcmp(Head{i},'A(adr)'),
        handles.index.AId = i-1;
    elseif strcmp(Head{i},'B(x)'),
        handles.index.BxI = i-1;
    elseif strcmp(Head{i},'B(y)'),
        handles.index.ByI = i-1;
    elseif strcmp(Head{i},'B(z)'),
        handles.index.BzI = i-1;
    elseif strcmp(Head{i},'B(adr)'),
        handles.index.BId = i-1;
    elseif strcmp(Head{i},'M(x)'),
        handles.index.MxI = i-1;
    elseif strcmp(Head{i},'M(y)'),
        handles.index.MyI = i-1;
    elseif strcmp(Head{i},'M(z)'),
        handles.index.MzI = i-1;
    elseif strcmp(Head{i},'M(adr)'),
        handles.index.MId = i-1;
    elseif strcmp(Head{i},'N(x)'),
        handles.index.NxI = i-1;
    elseif strcmp(Head{i},'N(y)'),
        handles.index.NyI = i-1;
    elseif strcmp(Head{i},'N(z)'),
        handles.index.NzI = i-1;
    elseif strcmp(Head{i},'N(adr)'),        
        handles.index.NId = i-1;
    else
        for j = 1 : 17,
            head_IP = sprintf('IP #%d(mV/V)',j);
            if strcmp(Head{i},head_IP)
                handles.index.IP(j) = i-1;
                break
            end
        end
    end            
    headers = erase(headers,Head{i});
    headers = strtrim(headers);
    i = i + 1;
end
i = i-2;
handles.data = dlmread(handles.fileID,'\t',[find(indexHead==1,1,'first'),1,find(indexEnd==1,1,'first')-3,i]);
handles.isIP = sum(~isnan(handles.index.IP)); 
if max(handles.data(:,handles.index.Var))>10,
    histogram(handles.axes_hist,handles.data(:,handles.index.Var),0:0.5:10);
else
    histogram(handles.axes_hist,handles.data(:,handles.index.Var));
end
xlabel('Error (%)');

% Finding the electrodes positions:
if min(handles.data(:,handles.index.MyI))~=max(handles.data(:,handles.index.MyI)),
    % We have a 3D dataset
    handles.electrodes = unique([handles.data(:,[handles.index.AxI handles.index.AyI]);handles.data(:,[handles.index.BxI handles.index.ByI]);...
        handles.data(:,[handles.index.MxI handles.index.MyI]);handles.data(:,[handles.index.NxI handles.index.NyI])],'rows');
else
    % We have a 2D dataset
    handles.electrodes = unique([handles.data(:,handles.index.AxI);handles.data(:,handles.index.BxI);handles.data(:,handles.index.MxI);handles.data(:,handles.index.NxI)]);
end

set(handles.axes_hist,'Visible','on');
set(handles.title_hist,'Visible','on');
set(handles.thresh,'Visible','on');
set(handles.thresh_edit,'Visible','on');
set(handles.thresh_units,'Visible','on');
set(handles.pushbuttonRES2DINV,'Visible','on');
set(handles.pushbuttonRES3DINV,'Visible','on');
set(handles.pushbuttonAarhusInv,'Visible','on');
set(handles.pushbuttonCRTomo,'Visible','on');
set(handles.pushbuttonBERT,'Visible','on');

guidata(hObject, handles);


function thresh_edit_Callback(hObject, eventdata, handles)
% hObject    handle to thresh_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thresh_edit as text
%        str2double(get(hObject,'String')) returns contents of thresh_edit as a double


% --- Executes during object creation, after setting all properties.
function thresh_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thresh_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonRES2DINV.
function pushbuttonRES2DINV_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonRES2DINV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% The RES3DINV format:

% NAME
% Min elec. spacing
% Type of array (general = 11)
% Sub-array type (0)
% Type of measurement
% 0
% Number of data points
% Type of x location (1 = true)
% Flag for IP (0)
% 4 Ax Ay Bx By Mx My Nx Ny rhoa
% 0
% 0

thresh = str2double(get(handles.thresh_edit,'String'));
[~, file, ~] = fileparts(handles.fileID);
if size(handles.electrodes,2) ~= 1,
    error(sprintf('The format you are trying to use is not compatible with 3-D datasets!\n'));
end
fid = fopen('tmp.txt','w');
fprintf(fid,'%s\n',file);% Name
nbElec = length(handles.electrodes);
min_space = min(abs(handles.electrodes(1:end-1)-handles.electrodes(2:end)));
fprintf(fid,'%f\n',min_space);% Min elect spacing
fprintf(fid,'%d\n%d\n',11,0);% Config
fprintf(fid,'Type of measurement\n');
fprintf(fid,'%d\n',0);% Type of measurement (app res) 
index = handles.data(:,handles.index.Var)<=thresh;
nbdata = sum(index);
fprintf(fid,'%d\n',nbdata);% Nb of data
fprintf(fid,'%d\n',1);% Type of x location
if handles.isIP == 0,
    fprintf(fid,'%d\n',0);% Flag for IP data
    for i = 1 : size(handles.data,1),
        if index(i),
            A = handles.data(i,[handles.index.AxI handles.index.AyI]);
            B = handles.data(i,[handles.index.BxI handles.index.ByI]);
            M = handles.data(i,[handles.index.MxI handles.index.MyI]);
            N = handles.data(i,[handles.index.NxI handles.index.NyI]);
            fprintf(fid,'%d\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t\n', 4, A(1), A(2), B(1), B(2), M(1), M(2), N(1), N(2),handles.data(i,handles.index.rhoa));
        end
    end
else
    fprintf(fid,'%d\n',1);%handles.isIP+1);% Flag for IP data
    fprintf(fid,'Chargeability\nmV/V\n');
    fprintf(fid,'%f\t%f\n',handles.IPWIN(1), sum(handles.IPWIN(2:end)));
    formatting = '%d\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n';
%     i = 1;
%     while ~isnan(handles.index.IP(i))
%         formatting = [formatting '%f\t'];
%         i = i + 1;
%     end
%     formatting = [formatting '\n'];
    for i = 1 : size(handles.data,1),
        if index(i),
            A = handles.data(i,[handles.index.AxI handles.index.AyI]);
            B = handles.data(i,[handles.index.BxI handles.index.ByI]);
            M = handles.data(i,[handles.index.MxI handles.index.MyI]);
            N = handles.data(i,[handles.index.NxI handles.index.NyI]);
            IPval = (handles.data(i,handles.index.IP(~isnan(handles.index.IP)))*handles.IPWIN(2:end)')/sum(handles.IPWIN(2:end));
            fprintf(fid,formatting, 4, A(1), A(2), B(1), B(2), M(1), M(2), N(1), N(2),handles.data(i,handles.index.rhoa),IPval);
        end
    end
end    
fprintf(fid,'%d\n%d\n%d\n',0,0,0);
fclose(fid);
[file, path] = uiputfile('*.dat','Save RES2DINV data file');
copyfile('tmp.txt',[path file]);
delete('tmp.txt');



% --- Executes on button press in pushbuttonRES3DINV.
function pushbuttonRES3DINV_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonRES3DINV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% The RES3DINV format:

% NAME
% x grid size
% y grid size
% Nonuniform grid (header)
% x-location of grid-lines (header)
% x1 x2 x3 x4 etc.
% y-location of grid-lines (header)
% y1 y2 y3 y4 etc.
% Type of array (general = 11)
% Sub-type (0)
% Type of measurement (0=app.resistivity,1=resistance) (header)
% 1 # Prefer resistance values when the grid is 3D (app res are strange)
% Number of datum points
% 4 Ax Ay Bx By Mx My Nx Ny rho
% 0
% 0

thresh = str2double(get(handles.thresh_edit,'String'));
if size(handles.electrodes,2) ~= 2,
    error(sprintf('The format you are trying to use is not compatible with 2-D datasets!\n'));
end
[~, file, ~] = fileparts(handles.fileID);
fid = fopen('tmp.txt','w');
fprintf(fid,'%s\n',file);% Name
elecX = unique(handles.electrodes(:,1));
elecY = unique(handles.electrodes(:,2));
gridX = 2*length(elecX)-1;
gridY = 2*length(elecY)-1;
fprintf(fid,'%d\n',gridX);
fprintf(fid,'%d\n',gridY);
fprintf(fid,'Nonuniform grid\n');
fprintf(fid,'X-location of grid lines\n');
j = 1;
for i = 1 : gridX,
    if mod(i,2) ~= 0,
        fprintf(fid,'%d',elecX(j));
        j = j + 1;
    else
        fprintf(fid,'%d',(elecX(j)+elecX(j-1))/2);
    end
    if i ~= gridX,
        fprintf(fid,'\t');
    else
        fprintf(fid,'\n');
    end
end
fprintf(fid,'Y-location of grid lines\n');
j = 1;
for i = 1 : gridY,
    if mod(i,2) ~= 0,
        fprintf(fid,'%d',elecY(j));
        j = j + 1;
    else
        fprintf(fid,'%d',(elecY(j)+elecY(j-1))/2);
    end
    if i ~= gridY,
        fprintf(fid,'\t');
    else
        fprintf(fid,'\n');
    end
end
nbElec = length(handles.electrodes);
fprintf(fid,'%d\n%d\n',11,0);% Config
fprintf(fid,'Type of measurement\n');
fprintf(fid,'%d\n',1);% Type of measurement (res)
index = handles.data(:,handles.index.Var)<=thresh;
nbdata = sum(index);
fprintf(fid,'%d\n',nbdata);% Nb of data
for i = 1 : size(handles.data,1),
    if index(i),
        A = handles.data(i,[handles.index.AxI handles.index.AyI]);
        B = handles.data(i,[handles.index.BxI handles.index.ByI]);
        M = handles.data(i,[handles.index.MxI handles.index.MyI]);
        N = handles.data(i,[handles.index.NxI handles.index.NyI]);
        fprintf(fid,'%d\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t\n', 4, A(1), A(2), B(1), B(2), M(1), M(2), N(1), N(2),handles.data(i,handles.index.rho));
    end
end
fprintf(fid,'%d\n%d\n%d\n',0,0,0);
fclose(fid);

[file, path] = uiputfile('*.dat','Save RES3DINV data file');
copyfile('tmp.txt',[path file]);
delete('tmp.txt');


% --- Executes on button press in pushbuttonAarhusInv.
function pushbuttonAarhusInv_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonAarhusInv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% The AarhusInv data format

% Header line: xA	xB	xM	xN	dA	dB	dM	dN	UTMxA	UTMxB	UTMxM
% UTMxN	UTMyA	UTMyB	UTMyM	UTMyN	sA	sB	sM	sN	Res	Rho	Dev ResFlag
% Tha data points with EXACT coordonates

AIHeaders = {'xA','xB','xM','xN','dA','dB','dM','dN','UTMxA','UTMxB','UTMxM','UTMxN',...
    'UTMyA','UTMyB','UTMyM','UTMyN','sA','sB','sM','sN','Res','Rho','Dev', 'ResFlag'};
ABEMHeaders = [handles.index.AxI, handles.index.BxI, handles.index.MxI, handles.index.NxI, NaN, NaN, NaN, NaN, handles.index.AxI, handles.index.BxI, handles.index.MxI, handles.index.NxI, ...
    NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, handles.index.rho, handles.index.rhoa, handles.index.Var, NaN];

fid = fopen('tmp.txt','w');
for i = 1 : length(AIHeaders),
    fprintf(fid,'%s',AIHeaders{i});
    if i ~= length(AIHeaders),
        fprintf(fid,'\t');
    else
        fprintf(fid,'\n');
    end
end
thresh = str2double(get(handles.thresh_edit,'String'));
index = handles.data(:,handles.index.Var)<=thresh;
for i = 1 : size(handles.data,1),
    if index(i),
        for j = 1 : length(ABEMHeaders),
            if ~isnan(ABEMHeaders(j)),
                fprintf(fid,'%f',handles.data(i,ABEMHeaders(j)));
            else
                fprintf(fid,'%d',0);
            end
            if j ~= length(ABEMHeaders),
                fprintf(fid,'\t');
            else
                fprintf(fid,'\n');
            end
        end
    end
end
fclose(fid);
[file, path] = uiputfile('*.tx2','Save AarhusInv data file');
copyfile('tmp.txt',[path file]);
delete('tmp.txt');


% --- Executes on button press in pushbuttonCRTomo.
function pushbuttonCRTomo_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonCRTomo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% The CRTomo data format

% Nb of data
% aId bId mId nId rhoa err

thresh = str2double(get(handles.thresh_edit,'String'));

[file,path] = uigetfile('*.dat','Select the mesh file');
fid = fopen([path file]);
nbNodes = textscan(fid,'%d\t',1);
fclose(fid);
nbNodes = nbNodes{1};
nodes = dlmread([path file],'\t',[4 0 nbNodes+3 2]);
elect = handles.electrodes;
fid = fopen('tmpElec.txt','w');
fprintf(fid,'%d\n',length(elect));
for i = 1 : length(elect),
    [~,idN] = ismember(elect(i,1),nodes(:,2));
    idN = nodes(idN,1);
    fprintf(fid,'%d\n',idN);
end
fclose(fid);    

nbElec = length(handles.electrodes);
fid = fopen('tmp.txt','w');
index = handles.data(:,handles.index.Var)<=thresh;
nbdata = sum(index);
fprintf(fid,'%d\n',nbdata);
electrodes = handles.electrodes;
if size(electrodes,2) == 1,
    electrodes = [electrodes, zeros(nbElec,1)];
end
for i = 1 : size(handles.data,1),
    if index(i),
        A = handles.data(i,[handles.index.AxI handles.index.AyI]);
        B = handles.data(i,[handles.index.BxI handles.index.ByI]);
        M = handles.data(i,[handles.index.MxI handles.index.MyI]);
        N = handles.data(i,[handles.index.NxI handles.index.NyI]);
        [~, a] = ismember(A,electrodes,'rows');
        [~, b] = ismember(B,electrodes,'rows');
        [~, m] = ismember(M,electrodes,'rows');
        [~, n] = ismember(N,electrodes,'rows');
        fprintf(fid,'%d\t%d\t%d\t%d\t%f\t%f\n',a,b,m,n,handles.data(i,handles.index.rhoa),handles.data(i,handles.index.Var));
    end
end
fclose(fid);

[file, path] = uiputfile('*.dat','Save CRTomo data file');
copyfile('tmp.txt',[path file]);
copyfile('tmpElec.txt',[path 'elec.dat']);
warning(sprintf('Use the ''elec.dat'' file given in the same folder!!\n'));
delete('tmp.txt');
delete('tmpElec.txt');


% --- Executes on button press in pushbuttonBERT.
function pushbuttonBERT_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonBERT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% The unified data format

% Nb. of electrodes
% ElectX ElectY
% Nb. of data
% a b m n rhoa err (Header)
% aId bId mId nId  rhoa err

thresh = str2double(get(handles.thresh_edit,'String'));

fid = fopen('tmp.txt','w');
nbElec = length(handles.electrodes);
fprintf(fid,'%d\n',nbElec);
fprintf(fid,'#x\tz\tposition for each electrode\n');
if size(handles.electrodes,2)==1,
    for i = 1 : nbElec,
        fprintf(fid,'%f\t%f\n',handles.electrodes(i),0);
    end
else
    for i = 1 : nbElec,
        fprintf(fid,'%f\t%f\n',handles.electrodes(i,1),handles.electrodes(i,2));
    end
end
index = handles.data(:,handles.index.Var)<=thresh;
nbdata = sum(index);
fprintf(fid,'%d\n',nbdata);
electrodes = handles.electrodes;
if size(electrodes,2) == 1,
    electrodes = [electrodes, zeros(nbElec,1)];
end
fprintf(fid,'#a\tb\tm\tn\trhoa\terr/%%\n');
for i = 1 : size(handles.data,1),
    if index(i),
        A = handles.data(i,[handles.index.AxI handles.index.AyI]);
        B = handles.data(i,[handles.index.BxI handles.index.ByI]);
        M = handles.data(i,[handles.index.MxI handles.index.MyI]);
        N = handles.data(i,[handles.index.NxI handles.index.NyI]);
        [~, a] = ismember(A,electrodes,'rows');
        [~, b] = ismember(B,electrodes,'rows');
        [~, m] = ismember(M,electrodes,'rows');
        [~, n] = ismember(N,electrodes,'rows');
        fprintf(fid,'%d\t%d\t%d\t%d\t%f\t%f\n',a,b,m,n,handles.data(i,handles.index.rhoa),handles.data(i,handles.index.Var));
    end
end
fclose(fid);

[file, path] = uiputfile('*.dat','Save BERT data file');
copyfile('tmp.txt',[path file]);
delete('tmp.txt');
