package test;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONObject;


/**
 * Servlet implementation class test
 */
@WebServlet("/hello")
public class test extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public test() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
   

    String cor;
    String add;
    String out;
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		System.out.println("getcor : "+cor);
		System.out.println("getadd : "+add);
		
		JSONObject j = new JSONObject(cor);
		String CorX = String.valueOf(j.get("lat"));
		String CorY = String.valueOf(j.get("lng"));	
		System.out.println("address : "+add+" x : "+CorX+" y : "+CorY);
		
		Connection conn = null;
		Statement stmt = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			
			Class.forName("oracle.jdbc.driver.OracleDriver");
			String url = "jdbc:oracle:thin:@localhost:1521:dbecrdb";
			conn = DriverManager.getConnection(url, "scott", "tiger"); 
			stmt = conn.createStatement();
			pstmt = conn.prepareStatement("INSERT INTO CORDATA VALUES (SEQ_ID.NEXTVAL, ?, ?, ?)");
			pstmt.setString(1, add);
			pstmt.setString(2, CorX);
			pstmt.setString(3, CorY);
			pstmt.executeUpdate();
			rs = stmt.executeQuery("select * from CORDATA");
			while(rs.next()) {
				System.out.println("ossdasfasdsdsddk");
				System.out.println(rs.getString("address"));
				System.out.println(rs.getString("corx"));
				System.out.println(rs.getString("cory"));
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			try {
			if(rs != null)  rs.close();
			if(pstmt != null) pstmt.close();
			if(stmt != null) stmt.close();
			if(conn != null) conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		
	      
		 ServletContext context =getServletContext();
	        RequestDispatcher dispatcher = context.getRequestDispatcher("/GetJson.jsp"); //넘길 페이지 주소
	        request.setAttribute("content", cor);
	        request.setAttribute("content1", add);
	        dispatcher.forward(request, response);
	}
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// TODO Auto-generated method stub
		req.setCharacterEncoding("UTF-8");
		cor = req.getParameter("cor");
		add = req.getParameter("add");
		System.out.println("postcor : "+cor);
		System.out.println("postadd : "+add);
		
		//resp.sendRedirect("dbec.pknu.ac.kr/NaverMapPractice/GetJson.jsp");
		
  
        
       
        
	}
}
