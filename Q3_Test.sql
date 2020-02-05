--5-12
CREATE OR REPLACE PROCEDURE DDCKPAY_SP
    (payment_amt in dd_pledge.pledgeamt%TYPE,
     pledge_id in dd_pledge.idpledge%TYPE)
AS
BEGIN
    DECLARE 
        planned_amt dd_pledge.pledgeamt%TYPE;
        pledge_amt dd_pledge.pledgeamt%TYPE;
        pay_month dd_pledge.paymonths%TYPE;
    BEGIN
        SELECT pledgeamt,paymonths
        into pledge_amt,pay_month
        from dd_pledge
        where idpledge=pledge_id;
        if pay_month=0 then
            dbms_output.put_line('NO PAYMENT INFORMATION');  
        else
            planned_amt:=pledge_amt/pay_month;
                if payment_amt!=planned_amt then
                planned_amt:=payment_amt-planned_amt;
                    dbms_output.put_line('Incorrect payment amount-planned payment= '||planned_amt);
                   raise_application_error(-20050,'Incorrect payment amount - planned payment= '||planned_amt);
                else
                   dbms_output.put_line('CONFIRM CORRECT'); 
                END IF;  
        END IF;
    END;    
END;

--5-12 test
BEGIN DDCKPAY_SP(25,104); 
end;
BEGIN DDCKPAY_SP(20,104); 
end;
BEGIN DDCKPAY_SP(20,103); 
end;