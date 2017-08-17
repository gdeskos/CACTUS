        SUBROUTINE corrector()     
    
!*********************************************************************!
! This is a loop that convects the lattice points
! NT  : Number of Time Steps
! NE  : Number of Lattice Points
! iut : Number of iterations between wake convection velocity updates
! flag : It sets the time marching scheme (2:
!*********************************************************************!
        use configr
        use blade
        use regtest
        logical NotDone
        integer :: flag

        !##################
        !# Corrector
        !##################                                 
                                                      
        
        ! Calculate the freestream velocity at wake locations at
        ! N Time step
        ygcErr=0
                                          
        

        ! Calculate freestream velocity at wake locations
        ygcErr=0
        do I=1,NE                                                      
        do J=ntTerm,NT
        CALL CalcFreestream(X(J,I),Y(J,I),Z(J,I),UFStilde(J,I),VFStilde(J,I),WFStilde(J,I),ygcErr)                                 
        end do
        end do
        
        
            do I=1,NE                                                      
            do J=ntTerm,NT
        
            ! Calculate wall and wake induced velocities at wake locations 
        
            Call CalcIndVel(NT,ntTerm,NBE,NB,NE,X(J,I),Y(J,I),Z(J,I),Utilde(J,I),Vtilde(J,I),Wtilde(J,I))                                                                    
            end do
            end do
        

        do I=1,NE                                                      
        do J=ntTerm,NT                                           
        ! convecting the wake (use velocity extrapolated to t=t+.5*dt)
        Utilde(J,I)=Utilde(J,I)+UFStilde(J,I)
        Vtilde(J,I)=Vtilde(J,I)+VFStilde(J,I)
        Wtilde(J,I)=Wtilde(J,I)+WFStilde(J,I)
        end do
        end do
                  
                                                     
        do I=1,NE                                                      
        do J=ntTerm,NT1                                                
        X(J,I)=XO(J,I)+0.5*(Utilde(J,I)+UO(J,I))*DT
        Y(J,I)=YO(J,I)+0.5*(Vtilde(J,I)+VO(J,I))*DT
        Z(J,I)=ZO(J,I)+0.5*(Wtilde(J,I)+WO(J,I))*DT
        end do
        end do

        
        Return                   
        End SUBROUTINE corrector 

