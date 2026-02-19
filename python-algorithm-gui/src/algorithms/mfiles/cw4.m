clear all
clc

w11= -0.3 ;
w12=0.1 ;
w21=0.05 ;
w22=-0.17 ;
w31=-0.7 ;
w32=-0.2 ;

ddw32 = 0 ;
ddw31 = 0;
ddw22 = 0;
ddw21 = 0;
ddw12 = 0;
ddw11 = 0;

for i1=[0.1 , 0.9]
  for i2 = [0.1 , 0.9]
    ot = 0.1 * (i1==i2) + 0.9 * (i1 ~= i2)

    o = (i1*w11 + i2*w21)*w31 + (i1*w12 + i2*w22)*w32
    e=ot-o
    e21 = e / w31
    e22 = e / w32

    ii1 = (i1*w11 + i2*w21)
    ii2 = (i1*w12 + i2*w22)

    dw32 = 0.1 * (e*ii2>0) - 0.1*(e*ii2<0)
    dw31 = 0.1 * (e*ii1>0) - 0.1*(e*ii1<0)
    dw22 = 0.1 * (e22*i2>0) - 0.1*(e22*i2<0)
    dw21 = 0.1 * (e21*i2>0) - 0.1*(e21*i2<0)
    dw12 = 0.1 * (e22*i1>0) - 0.1*(e22*i1<0)
    dw11 = 0.1 * (e21*i1>0) - 0.1*(e21*i1<0)
    printf('\n\n')
    ddw32 = ddw32 + dw32/4 ;
    ddw31 = ddw31 + dw31/4 ;
    ddw22 = ddw22 + dw22/4 ;
    ddw21 = ddw21 + dw21/4 ;
    ddw12 = ddw12 + dw12/4 ;
    ddw11 = ddw11 + dw11/4 ;

  endfor
endfor

printf('dw11=%6.4f \t dw12=%6.4f \t dw21=%6.4f \t dw22=%6.4f \t ', ddw11 , ddw12 , ddw21 , ddw22 )
printf('\ndw31=%6.4f \t dw32=%6.4f \n\n', ddw31 , ddw32 )
