drop sequence INSTALLMENTS_PAID_SEQ;
CREATE SEQUENCE HR.INSTALLMENTS_PAID_SEQ
  START WITH 1
  MAXVALUE 999999999999999999999999999;


delete from INSTALLMENTS_PAID;
declare
v_no_of_inst number (2);
v_date date;
v_ins_amm number (10, 2);
cursor contr_curs is
select * from contracts; 
begin


for contr_rec in contr_curs loop

select CONTRACT_STARTDATE,  months_between(CONTRACT_ENDDATE, CONTRACT_STARTDATE)/12, CONTRACT_TOTAL_FEES - nvl(CONTRACT_DEPOSIT_FEES, 0)
INTO v_date, v_no_of_inst , v_ins_amm
FROM contracts
where contracts.CONTRACT_ID = contr_rec.CONTRACT_ID;

if contr_rec.CONTRACT_PAYMENT_TYPE = 'ANNUAL' then
for i in 1..v_no_of_inst loop
INSERT INTO INSTALLMENTS_PAID
(CONTRACT_ID, INSTALLMENT_DATE, INSTALLMENT_AMOUNT, PAID)
VALUES
(contr_rec.CONTRACT_ID, v_date, v_ins_amm/v_no_of_inst, 0 );
v_date := add_months(v_date, 12 );
end loop;

elsif contr_rec.CONTRACT_PAYMENT_TYPE = 'HALF_ANNUAL' then
v_no_of_inst := v_no_of_inst*2;
for i in 1..v_no_of_inst loop
INSERT INTO INSTALLMENTS_PAID
(CONTRACT_ID, INSTALLMENT_DATE, INSTALLMENT_AMOUNT, PAID)
VALUES
(contr_rec.CONTRACT_ID, v_date, v_ins_amm/v_no_of_inst, 0 );
v_date := add_months(v_date, 6 );
end loop;

elsif contr_rec.CONTRACT_PAYMENT_TYPE = 'QUARTER' then
v_no_of_inst := v_no_of_inst*4;
for i in 1..v_no_of_inst loop
INSERT INTO INSTALLMENTS_PAID
(CONTRACT_ID, INSTALLMENT_DATE, INSTALLMENT_AMOUNT, PAID)
VALUES
(contr_rec.CONTRACT_ID, v_date, v_ins_amm/v_no_of_inst, 0 );
v_date := add_months(v_date, 3 );
end loop;

elsif contr_rec.CONTRACT_PAYMENT_TYPE = 'MONTHLY' then
v_no_of_inst := v_no_of_inst*12;
for i in 1..v_no_of_inst loop
INSERT INTO INSTALLMENTS_PAID
(CONTRACT_ID, INSTALLMENT_DATE, INSTALLMENT_AMOUNT, PAID)
VALUES
(contr_rec.CONTRACT_ID, v_date, v_ins_amm/v_no_of_inst, 0 );
v_date := add_months(v_date, 1 );
end loop;

end if;
end loop;

end;

