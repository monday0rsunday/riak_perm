package com.broship.user.service;

import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.apache.log4j.Logger;
import org.apache.log4j.LogManager;

import com.basho.riak.client.api.RiakClient;
import com.basho.riak.client.core.RiakCluster;
import com.basho.riak.client.core.RiakNode;
import com.basho.riak.client.core.RiakNode.Builder;

public class ContextListener implements ServletContextListener {
	// private static Logger logger =
	// Logger.getLogger(ContextListener.class.getSimpleName());
	public RiakCluster cluster = null;
	public RiakClient client = null;

	@Override
	public void contextInitialized(ServletContextEvent sce) {
		// logger.info("start listener");
		try {
			// RiakNode.Builder have perm gen leak when initialize any instance
			RiakNode.Builder builder = null;
			 // builder = new RiakNode.Builder();
			 // builder.withHealthCheck(null);
			 // builder.withMinConnections(Config.getRiakMinConn());
			 // builder.withMaxConnections(Config.getRiakMaxConn());
			//
			List<String> addresses = new LinkedList<String>();
			//addresses.addAll("192.168.1.1:8080".split(",")));
			// or memleak when call buildNodes also
			List<RiakNode> nodes = null;
			// nodes = RiakNode.Builder.buildNodes(builder, addresses);
			// cluster = new RiakCluster.Builder(nodes).build();
			// cluster.start();

			 client = RiakClient.newClient();
		} catch (Exception e) {
			// logger.info("init riak client error");
		}
		// logger.info("complete start listener");
	}

	@Override
	public void contextDestroyed(ServletContextEvent sce) {
		if (cluster != null)
			try{
				cluster.shutdown().get();
			}catch(Exception e){e.printStackTrace();}
		if (client !=null)
			try{
				client.shutdown().get();
			}catch(Exception e){e.printStackTrace();}
		// logger.info("destroy listener");
		// LogManager.shutdown();
	}

}
