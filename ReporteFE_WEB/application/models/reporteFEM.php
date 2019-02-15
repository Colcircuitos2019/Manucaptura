<?php 
/**
 * 
 */
class reporteFEM extends CI_Model 
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

		$query = $this->db->query("CALL PA_ConsultarEstadoLecturaFacilitador('98113053240');");

		$result = $query->row();

		return $result->estadoLectura;
	}

	public function consultarInformacionCuerpoTablaM()
	{
		$this->load->database();

		$query = $this->db->query("CALL PA_InformeNFE();");

		$result= $query->result();

		$this->db->close();

		return $result;
	}

	public function consultarNombreLiderProyectoENM($documento)
	{
		$db_sgn= $this->load->database('sgn',true);

		$query = $db_sgn->query("CALL PA_ConsultarEmpleadosColtime('{$documento}','');");

		$row= $query->row();

		$db_sgn->close();

		return $row;
	}
}
 ?>