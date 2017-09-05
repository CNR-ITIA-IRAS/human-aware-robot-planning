
path = 'C:\Users\NicolaPedrocchi\OneDrive - C.N.R. ITIA\Progetti\shared-vb\sperim_paper\exp1\';
fb ={'prova20170321_2017-03-20-14-27-53.bag' ...
    , 'prova20170321-2exp_2017-03-20-14-33-22.bag' ...
    , 'prova20170321-3exp_2017-03-20-14-36-53.bag'};
 
frames_used =  { '/skel/SpineBase' ...
                , '/skel/SpineMid'  ...
                , '/skel/Neck' ...
                , '/skel/Head' ...
                , '/skel/ShoulderLeft' ...
                , '/skel/ElbowLeft' ...
                , '/skel/WristLeft' ...
                , '/skel/HandLeft' ...
                , '/skel/ShoulderRight' ...
                , '/skel/ElbowRight' ...
                , '/skel/WristRight' ...
                , '/skel/HandRight' ...
                , '/skel/HipLeft' ...
                , '/skel/KneeLeft' ...
                , '/skel/AnkleLeft' ...
                , '/skel/FootLeft' ...
                , '/skel/HipRight' ...
                , '/skel/KneeRight' ...
                , '/skel/AnkleRight' ...
                , '/skel/FootRight' ...
                , '/skel/SpineShoulder' ...
                , '/skel/HandTipLeft' ...
                , '/skel/ThumbLeft' ...
                , '/skel/HandTipRight' ...
                , '/skel/ThumbRight' };
frames_msgs = cell( 1, length(frames_used) );

for exp=1:1
    
    bag = rosbag( [path,fb{exp} ] );
    msgs = {};
    dT = 0.1;
    dTBag = bag.EndTime - bag.StartTime;
    if dT > dTBag
        nBlock = 1 ;
        dT = dTBag;
    else
        nBlock = ceil( dTBag / dT );
    end
    st = bag.StartTime;
    for iBlock=1:nBlock 
        et = st + dT; 
        if mod( iBlock, 2 ) == 0
            disp([num2str(iBlock),'/',num2str(nBlock),' from ', num2str(st-bag.StartTime), ' to ', num2str(et-bag.StartTime), ' (dim Block: ', num2str( dT ), ')' ]);
            if iBlock == 1
                topics = select( bag, 'Time', [ st, et ], 'Topic', {'tf'} );
                tf = readMessages( topics );
            else
                topics = select( bag, 'Time', [ st, et ], 'Topic', {'tf'} );
                tf = cat(1, tf, readMessages( topics ) );
            end 
        end
        st = et;
    end
    
    for iMsg =1:length(tf)
        frameid = tf{iMsg}.Transforms.ChildFrameId;
%         if iMsg == 1 
%             frames = cat( 1, frames, frame );
%         end
        [ ok, idx ] = ismember( frameid , frames_used );
        if ok
            frames_msgs{ idx } = [ frames_msgs{ idx }, tf{iMsg} ];
        end
    end
    ts = cell(length( frames_msgs ),1 );
    for iFrame = 1:length( frames_msgs )
       [~,~, ts{iFrame} ] = extractData( frames_msgs{ idx }, bag.StartTime, frameid );
    end
    
end