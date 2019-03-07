<?php 
/**
 * 
 */
class reporteTEM extends CI_Model 
{
	
	function __construct()
	{
		parent::__construct();
	}

	public function estadoDeConexionServidorM()
	{
		try {
			// ...
			$this->load->database();
			// ...
			return 1;
		} catch (Exception $e) {
			return $e;
		}
	}

	public function estadoDeLecturaPuertoSerialM()
	{
		$this->load->database();

		$query = $this->db->query("CALL PA_ConsultarEstadoLecturaFacilitador('43975208');");

		$result = $query->row();

		return $result->estadoLectura;
	}

	public function estructurarEncabezadoM()
	{
		$this->load->database();

		$query = $this->db->query("CALL PA_ConsultarPRocesosReporteENoTE(2);");//El 3 hace referencia 

		$result= $query->result();

		$this->db->close();

		return $result;
	}

	public function consultarInformacionCuerpoTablaM()
	{
		$this->load->database();

		$query = $this->db->query("CALL PA_InformeNTE();");

		$result= $query->result();

		$this->db->close();

		return $result;
	}
}
 ?>