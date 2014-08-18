@echo off
rem MSVC90FREEOPTS.BAT
rem
rem    Compile and link options used for building MEX-files
rem    using the Microsoft Visual Studio 2008 Express Edition.
rem
rem    $Revision: 1.1.8.1 $  $Date: 2008/05/27 18:21:07 $
rem    Copyright 2008 The MathWorks, Inc.
rem
rem StorageVersion: 1.0
rem C++keyFileName: MSVC90FREEOPTS.BAT
rem C++keyName: Microsoft Visual C++ 2008 Express
rem C++keyManufacturer: Microsoft
rem C++keyVersion: 9.0
rem C++keyLanguage: C++
rem
rem ********************************************************************
rem General parameters
rem ********************************************************************

set MATLAB=%MATLAB%
set VS90COMNTOOLS=%VS90COMNTOOLS%
set VSINSTALLDIR=C:\Program Files (x86)\Microsoft Visual Studio 9.0
set VCINSTALLDIR=%VSINSTALLDIR%\VC
rem In this case, LINKERDIR is being used to specify the location of the SDK
set LINKERDIR=C:\Program Files\Microsoft SDKs\Windows\v7.1\
set PATH=%VCINSTALLDIR%\BIN\;%VSINSTALLDIR%\VC\bin;%LINKERDIR%\bin;%VSINSTALLDIR%\Common7\IDE;%VSINSTALLDIR%\Common7\Tools;%VSINSTALLDIR%\Common7\Tools\bin;%VCINSTALLDIR%\VCPackages;%MATLAB_BIN%;%PATH%
set INCLUDE=%VCINSTALLDIR%\ATLMFC\INCLUDE;%VCINSTALLDIR%\INCLUDE;%LINKERDIR%\include;%INCLUDE%
set LIB=%VCINSTALLDIR%\ATLMFC\LIB;%VCINSTALLDIR%\LIB;%LINKERDIR%\lib;%VSINSTALLDIR%\SDK\v2.0\lib;%MATLAB%\extern\lib\win32;%LIB%
set MW_TARGET_ARCH=win32

rem ********************************************************************
rem Compiler parameters
rem ********************************************************************
set COMPILER=cl
set COMPFLAGS=/c /Zp8 /GR /W3 /EHs /D_CRT_SECURE_NO_DEPRECATE /D_SCL_SECURE_NO_DEPRECATE /D_SECURE_SCL=1 /DMATLAB_MEX_FILE /nologo /MD
set OPTIMFLAGS=/O2 /Oy- /DNDEBUG
set DEBUGFLAGS=/Z7
set NAME_OBJECT=/Fo

rem ********************************************************************
rem Linker parameters
rem ********************************************************************
set LIBLOC=%MATLAB%\extern\lib\win32\microsoft
set LINKER=link

set LINKFLAGS=/dll /export:%ENTRYPOINT% /LIBPATH:"%LIBLOC%" libmx.lib libmex.lib libmat.lib /MACHINE:X86 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /incremental:NO /implib:"%LIB_NAME%.x" /MAP:"%OUTDIR%%MEX_NAME%%MEX_EXT%.map" opencv_calib3d230.lib opencv_calib3d230d.lib opencv_contrib230.lib opencv_contrib230d.lib opencv_core230.lib opencv_core230d.lib opencv_features2d230.lib opencv_features2d230d.lib opencv_flann230.lib opencv_flann230d.lib opencv_gpu230.lib opencv_gpu230d.lib opencv_haartraining_engine.lib opencv_haartraining_engined.lib opencv_highgui230.lib opencv_highgui230d.lib opencv_imgproc230.lib opencv_imgproc230d.lib opencv_legacy230.lib opencv_legacy230d.lib opencv_ml230.lib opencv_ml230d.lib opencv_objdetect230.lib opencv_objdetect230d.lib opencv_video230.lib opencv_video230d.lib
rem opencv_calib3d244.dll opencv_calib3d244d.dll opencv_contrib244.dll opencv_contrib244d.dll opencv_core244.dll opencv_core244d.dll opencv_features2d244.dll opencv_features2d244d.dll opencv_ffmpeg244.dll opencv_flann244.dll opencv_flann244d.dll opencv_gpu244.dll opencv_gpu244d.dll opencv_highgui244.dll opencv_highgui244d.dll opencv_imgproc244.dll opencv_imgproc244d.dll opencv_legacy244.dll opencv_legacy244d.dll opencv_ml244.dll opencv_ml244d.dll opencv_nonfree244.dll opencv_nonfree244d.dll opencv_objdetect244.dll opencv_objdetect244d.dll opencv_photo244.dll opencv_photo244d.dll opencv_stitching244.dll opencv_stitching244d.dll opencv_ts244.dll opencv_ts244d.dll opencv_video244.dll opencv_video244d.dll opencv_videostab244.dll opencv_videostab244d.dll 
rem opencv_calib3d243.lib opencv_calib3d243d.lib opencv_contrib243.lib opencv_contrib243d.lib opencv_core243.lib opencv_core243d.lib opencv_features2d243.lib opencv_features2d243d.lib opencv_flann243.lib opencv_flann243d.lib opencv_gpu243.lib opencv_gpu243d.lib opencv_haartraining_engine.lib opencv_haartraining_engined.lib opencv_highgui243.lib opencv_highgui243d.lib opencv_imgproc243.lib opencv_imgproc243d.lib opencv_legacy243.lib opencv_legacy243d.lib opencv_ml243.lib opencv_ml243d.lib opencv_nonfree243.lib opencv_nonfree243d.lib opencv_objdetect243.lib opencv_objdetect243d.lib opencv_photo243.lib opencv_photo243d.lib opencv_stitching243.lib opencv_stitching243d.lib opencv_ts243.lib opencv_ts243d.lib opencv_video243.lib opencv_video243d.lib opencv_videostab243.lib opencv_videostab243d.lib
rem opencv_calib3d230.lib opencv_calib3d230d.lib opencv_contrib230.lib opencv_contrib230d.lib opencv_core230.lib opencv_core230d.lib opencv_features2d230.lib opencv_features2d230d.lib opencv_flann230.lib opencv_flann230d.lib opencv_gpu230.lib opencv_gpu230d.lib opencv_haartraining_engine.lib opencv_haartraining_engined.lib opencv_highgui230.lib opencv_highgui230d.lib opencv_imgproc230.lib opencv_imgproc230d.lib opencv_legacy230.lib opencv_legacy230d.lib opencv_ml230.lib opencv_ml230d.lib opencv_objdetect230.lib opencv_objdetect230d.lib opencv_video230.lib opencv_video230.lib
rem cv210.lib cvaux210.lib cxcore210.lib cxts210.lib highgui210.lib ml210.lib opencv_ffmpeg210.lib cv210d.lib cvaux210d.lib cxcore210d.lib highgui210d.lib ml210d.lib opencv_ffmpeg210d.lib

set LINKOPTIMFLAGS=
set LINKDEBUGFLAGS=/DEBUG /PDB:"%OUTDIR%%MEX_NAME%%MEX_EXT%.pdb"
set LINK_FILE=
set LINK_LIB=
set NAME_OUTPUT=/out:"%OUTDIR%%MEX_NAME%%MEX_EXT%"
set RSP_FILE_INDICATOR=@

rem ********************************************************************
rem Resource compiler parameters
rem ********************************************************************
set RC_COMPILER=rc /fo "%OUTDIR%mexversion.res"
set RC_LINKER=

set POSTLINK_CMDS=del "%LIB_NAME%.x" "%LIB_NAME%.exp"
set POSTLINK_CMDS1=mt -outputresource:"%OUTDIR%%MEX_NAME%%MEX_EXT%;2" -manifest "%OUTDIR%%MEX_NAME%%MEX_EXT%.manifest"
set POSTLINK_CMDS2=del "%OUTDIR%%MEX_NAME%%MEX_EXT%.manifest"
set POSTLINK_CMDS3=del "%OUTDIR%%MEX_NAME%%MEX_EXT%.map"

rem ********************************************************************
rem OpenCV2.4.4
rem ********************************************************************
rem opencv_calib3d244.dll opencv_calib3d244d.dll opencv_contrib244.dll opencv_contrib244d.dll opencv_core244.dll opencv_core244d.dll opencv_features2d244.dll opencv_features2d244d.dll opencv_ffmpeg244.dll opencv_flann244.dll opencv_flann244d.dll opencv_gpu244.dll opencv_gpu244d.dll opencv_highgui244.dll opencv_highgui244d.dll opencv_imgproc244.dll opencv_imgproc244d.dll opencv_legacy244.dll opencv_legacy244d.dll opencv_ml244.dll opencv_ml244d.dll opencv_nonfree244.dll opencv_nonfree244d.dll opencv_objdetect244.dll opencv_objdetect244d.dll opencv_photo244.dll opencv_photo244d.dll opencv_stitching244.dll opencv_stitching244d.dll opencv_ts244.dll opencv_ts244d.dll opencv_video244.dll opencv_video244d.dll opencv_videostab244.dll opencv_videostab244d.dll 
rem set OCVDIR=C:\OpenCV2.4.4\build
rem set INCLUDE=%OCVDIR%\include;  %INCLUDE%
rem set LIB=%OCVDIR%\x86\vc9\lib;  %LIB%
rem set PATH=%OCVDIR%\x86\vc9\bin; %PATH%

rem rem ********************************************************************
rem rem OpenCV2.4.3
rem rem ********************************************************************
rem rem opencv_calib3d243.lib opencv_calib3d243d.lib opencv_contrib243.lib opencv_contrib243d.lib opencv_core243.lib opencv_core243d.lib opencv_features2d243.lib opencv_features2d243d.lib opencv_flann243.lib opencv_flann243d.lib opencv_gpu243.lib opencv_gpu243d.lib opencv_haartraining_engine.lib opencv_haartraining_engined.lib opencv_highgui243.lib opencv_highgui243d.lib opencv_imgproc243.lib opencv_imgproc243d.lib opencv_legacy243.lib opencv_legacy243d.lib opencv_ml243.lib opencv_ml243d.lib opencv_nonfree243.lib opencv_nonfree243d.lib opencv_objdetect243.lib opencv_objdetect243d.lib opencv_photo243.lib opencv_photo243d.lib opencv_stitching243.lib opencv_stitching243d.lib opencv_ts243.lib opencv_ts243d.lib opencv_video243.lib opencv_video243d.lib opencv_videostab243.lib opencv_videostab243.lib
rem set OCVDIR=C:\OpenCV2.4.3\build
rem set INCLUDE=%OCVDIR%\include;  %INCLUDE%
rem set LIB=%OCVDIR%\x86\vc9\lib;  %LIB%
rem set PATH=%OCVDIR%\x86\vc9\bin; %PATH%

rem rem ********************************************************************
rem rem OpenCV2.3
rem rem ********************************************************************
rem rem opencv_calib3d230.lib opencv_calib3d230d.lib opencv_contrib230.lib opencv_contrib230d.lib opencv_core230.lib opencv_core230d.lib opencv_features2d230.lib opencv_features2d230d.lib opencv_flann230.lib opencv_flann230d.lib opencv_gpu230.lib opencv_gpu230d.lib opencv_haartraining_engine.lib opencv_haartraining_engined.lib opencv_highgui230.lib opencv_highgui230d.lib opencv_imgproc230.lib opencv_imgproc230d.lib opencv_legacy230.lib opencv_legacy230d.lib opencv_ml230.lib opencv_ml230d.lib opencv_objdetect230.lib opencv_objdetect230d.lib opencv_video230.lib opencv_video230.lib
set OCVDIR=C:\OpenCV2.3\build
set INCLUDE=%OCVDIR%\include;  %INCLUDE%
set LIB=%OCVDIR%\x86\vc9\lib;  %LIB%
set PATH=%OCVDIR%\x86\vc9\bin; %OCVDIR%\bin; %PATH%

rem rem ********************************************************************
rem rem OpenCV2.1
rem rem ********************************************************************
rem rem cv210.lib cvaux210.lib cxcore210.lib cxts210.lib highgui210.lib ml210.lib opencv_ffmpeg210.lib cv210d.lib cvaux210d.lib cxcore210d.lib highgui210d.lib ml210d.lib opencv_ffmpeg210d.lib
rem set OCVDIR=C:\OpenCV2.1
rem set INCLUDE=%OCVDIR%\include; %INCLUDE%
rem set LIB=%OCVDIR%\lib; %LIB%
rem set PATH=%OCVDIR%\bin; %PATH%