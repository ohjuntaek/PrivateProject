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
   

    String json;
    String out;
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		System.out.println("get : "+json);
		
		JSONObject j = new JSONObject(json);
		JSONObject result = j.getJSONObject("result");
		JSONArray items = result.getJSONArray("items");
		String address = items.getJSONObject(0).getString("address");
		String CorX = String.valueOf(items.getJSONObject(0).getJSONObject("point").getInt("x"));
		String CorY = String.valueOf(items.getJSONObject(0).getJSONObject("point").getInt("y"));	
		System.out.println("address : "+address+" x : "+CorX+" y : "+CorY);
		
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
			pstmt.setString(1, address);
			pstmt.setString(2, CorX);
			pstmt.setString(3, CorY);
			pstmt.executeUpdate();
			rs = stmt.executeQuery("select * from CORDATA");
			while(rs.next()) {
				System.out.println("ossdfasdsdsddk");
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
	        request.setAttribute("content", json);
	        dispatcher.forward(request, response);
	}
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// TODO Auto-generated method stub
		req.setCharacterEncoding("UTF-8");
		json = req.getParameter("json");
		System.out.println("post : "+json);
		//resp.sendRedirect("dbec.pknu.ac.kr/NaverMapPractice/GetJson.jsp");
		
  
        
       
        
	}
}
