/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.frameapp.web.uad;

import java.util.Enumeration;
import java.util.Hashtable;

public class Request {

	Request() {
		m_parameters = new Hashtable();
		m_counter = 0;
	}

	protected void putParameter(String name, String value) {
		if (name == null)
			throw new IllegalArgumentException(
					"[Amarsoft Upload]The name of an element cannot be null.");
		if (m_parameters.containsKey(name)) {
			Hashtable values = (Hashtable) m_parameters.get(name);
			values.put(new Integer(values.size()), value);
		} else {
			Hashtable values = new Hashtable();
			values.put(new Integer(0), value);
			m_parameters.put(name, values);
			m_counter++;
		}
	}

	public String getParameter(String name) {
		if (name == null)
			throw new IllegalArgumentException(
					"[Amarsoft Upload]Form's name is invalid or does not exist (1305).");
		Hashtable values = (Hashtable) m_parameters.get(name);
		if (values == null)
			return null;
		else
			return (String) values.get(new Integer(0));
	}

	public Enumeration getParameterNames() {
		return m_parameters.keys();
	}

	public String[] getParameterValues(String name) {
		if (name == null)
			throw new IllegalArgumentException(
					"[Amarsoft Upload]Form's name is invalid or does not exist (1305).");
		Hashtable values = (Hashtable) m_parameters.get(name);
		if (values == null)
			return null;
		String strValues[] = new String[values.size()];
		for (int i = 0; i < values.size(); i++)
			strValues[i] = (String) values.get(new Integer(i));

		return strValues;
	}

	private Hashtable m_parameters;
	private int m_counter;
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\work\ALS7\WebRoot\WEB-INF\lib\awe-c2-b90-rc2_g.jar
	Total time: 277 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/