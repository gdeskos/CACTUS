        SUBROUTINE WriteWakeTime()   

! Write wake data outputs
        use wakedata
        use blade
        use wallsoln 
        use configr

        implicit none
        
        integer ::tcount,wcount
        real :: time
        character(80) ::Wake3D_basis,Wake_filename,format_string,format_line
        Wake3D_basis='wake_'
        if (NT<10) then
        format_string = "(A5,I1,A4)"
        else if(NT<100.AND.NT>=10) then
        format_string = "(A5,I2,A4)"
        else if(NT<1000.AND.NT>=100) then
        format_string = "(A5,I3,A4)"
        end if
         
        write(Wake_filename,format_string) Wake3D_basis, NT,'.dat'
        OPEN(100, FILE=Wake_filename)
        write(100,*) 'X/R Y/R Z/R U/R V/R W/R'
        format_line='(I3,I2,E13.7,E13.7,E13.7,E13.7,E13.7,E13.7)'
        do wcount=1,NE       
            do tCount=1,NT
        write(100,*)NT,' ',wcount,' ',X(tcount,wcount),' ',Y(tcount,wcount),' ',Z(tcount,wcount),' ',U(tcount,wcount),' ',V(tcount,wcount),' ',W(tcount,wcount)  
            end do
        end do

        close(100)
        
        End SUBROUTINE WriteWakeTime
    
