/*
SGDB: PostgreSQL
Programador: Isidoro Nevares Martín
Fecha: 17/02/2025
Script: Script que permite probar los modos (IN, OUT, INOUT) de los parámetros de un PROCEDIMIENTO.
		El funcionamiento de los modos (IN, OUT, INOUT) de los parámetros serían igualmente válido para una FUNCIÓN
 */
create or replace procedure p_probar_modos_parametros(in param_entrada int, out param_salida int, inout param_entrada_salida int)
	as $$
declare
begin 
	raise notice '	DENTRO PROCEDIMIENTO - INCIO: valores de param_entrada: %, param_salida % y  param_entrada_salida: %', param_entrada ,param_salida, param_entrada_salida;
	param_entrada:=11;
	param_salida:=22;
	param_entrada_salida:=33;
	raise notice '	DENTRO PROCEDIMIENTO - FIN: valores de param_entrada: %, param_salida % y  param_entrada_salida: %', param_entrada ,param_salida, param_entrada_salida;
end;
$$ language plpgsql;

do $$
declare
	-- Define variables para los parámetros del procedimiento.
	v_entrada int:=1;
	v_salida int:=2;
	v_entrada_salida int:=3;
begin 
	raise notice '--------------------------------------------------';
	raise notice 'ANTES PROCEDIMIENTO: valores de v_entrada: %, v_salida % y  v_entrada_salida: %', v_entrada ,v_salida, v_entrada_salida;
	call p_probar_modos_parametros(v_entrada, v_salida, v_entrada_salida);
	raise notice 'DESPUÉS PROCEDIMIEBTO: valores de v_entrada: %, v_salida % y  v_entrada_salida: %', v_entrada ,v_salida, v_entrada_salida;
	raise notice '--------------------------------------------------';
end;
$$
