        SUBROUTINE WriteFSTime()   

! Write wake data outputs
        use wakedata
        use wallsoln 
        use configr
        use varscale
        implicit none
        
        integer :: i
        real :: Tvel, dH
        real, allocatable :: TVelIFS(:,:)   
        
        character(80) ::FS3D_basis,FS_filename,format_string,format_line
        FS3D_basis='fs_'
        if (NT<10) then
        format_string = "(A3,I1,A4)"
        else if(NT<100.AND.NT>=10) then
        format_string = "(A3,I2,A4)"
        else if(NT<1000.AND.NT>=100) then
        format_string = "(A3,I3,A4)"
        end if
         
        write(FS_filename,format_string) FS3D_basis, NT,'.dat'
        OPEN(200, FILE=FS_filename)
        write(200,*) 'X/R Y/R DH/R '
        
        ! Calc tangential velocity induced by free surface 
        allocate(TVelIFS(NumFSCP,1))
        TVelIFS=matmul(FSInCoeffT,FSSource)

        do i=1,NumFSCP
        ! Get average tangential velocity on free surface
        TVel=FSVT(i,1)+TVelIFS(i,1)

        ! Calc dH (over radius)
        dH=0.5*FnR**2*(1-TVel**2)
        write(200,*)NT,' ',NumFSCP,' ',FSCPPoints(i,1)/ Rmax,' ',(FSCPPoints(i,2)+dH)/Rmax,' ',FSCPPoints(i,3)/Rmax  
        end do

        close(200)
       
        deallocate(TVELIFS)

        End SUBROUTINE WriteFSTime

