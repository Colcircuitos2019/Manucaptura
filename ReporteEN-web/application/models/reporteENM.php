<?php 
/**
 * 
 */
class reporteENM extends CI_Model 
{
	
	function __construct()
	{
		parent::__construct();
		$this->load->database();
	}

	public function estadoDeConexionServidorM()
	{
		# code...
	}

	public function estructurarEncabezadoM()
	{
		$query = $this->db->query("CALL PA_ConsultarPRocesosReporteENoTE(3);");//El 3 hace referencia 

		$result= $query->result();

		return $result;
	}

	public function consultarInformacionCuerpoTablaM()
	{
		$query = $this->db->query("CALL PA_InformeNEN();");

		$result= $query->result();

		return $result;
	}
}
 ?>