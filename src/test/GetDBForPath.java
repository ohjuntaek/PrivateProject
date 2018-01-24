package test;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class GetDBForPath
 */
@WebServlet("/GetDBForPath")
public class GetDBForPath extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetDBForPath() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.setCharacterEncoding("EUC-KR");
		response.getWriter().append("Served at: 시부랄!! ").append(request.getContextPath());
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		try {
			
			Class.forName("oracle.jdbc.driver.OracleDriver");
			String url = "jdbc:oracle:thin:@localhost:1521:dbecrdb";
			conn = DriverManager.getConnection(url, "scott", "tiger"); 
			stmt = conn.createStatement();
			rs = stmt.executeQuery("select * from CORDATA order by DATANUM");
			List<CorDataVO> list = new ArrayList<CorDataVO>();
			while(rs.next()) {
				CorDataVO cr = new CorDataVO();
				cr.setNum(rs.getInt("datanum"));
				cr.setAddress(rs.getString("address"));
				cr.setCorX(Double.parseDouble(rs.getString("corx")));
				cr.setCorY(Double.parseDouble(rs.getString("cory")));
				list.add(cr);
			}
			
			request.setAttribute("cdata", list);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			try {
			if(rs != null)  rs.close();
			if(stmt != null) stmt.close();
			if(conn != null) conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		RequestDispatcher dispatcher = request.getRequestDispatcher("FindPathTest.jsp");
		dispatcher.forward(request, response); 
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
