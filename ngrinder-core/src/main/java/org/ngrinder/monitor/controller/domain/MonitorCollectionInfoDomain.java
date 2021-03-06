/* 
 * Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License. 
 */
package org.ngrinder.monitor.controller.domain;

import javax.management.ObjectName;

import org.apache.commons.lang.builder.ToStringBuilder;
import org.apache.commons.lang.builder.ToStringStyle;

import org.ngrinder.monitor.share.domain.MonitorInfo;

/**
 * 
 * Monitor collection info domain.
 *
 * @author Mavlarn
 * @since 2.0
 */
public class MonitorCollectionInfoDomain {
	private ObjectName objectName;
	private String attrName;
	@SuppressWarnings("unused")
	private Class<? extends MonitorInfo> resultClass;

	/**
	 * Constructor for the collection info.
	 * @param objectName is the object name related with JMX domain name
	 * @param attrName	is the attribute name in this domain, used to get concrete monitor data
	 * @param resultClass is the Class type of that monitor data with that attribute name
	 */
	public MonitorCollectionInfoDomain(ObjectName objectName, String attrName,
			Class<? extends MonitorInfo> resultClass) {
		this.objectName = objectName;
		this.attrName = attrName;
		this.resultClass = resultClass;
	}

	public ObjectName getObjectName() {
		return objectName;
	}

	public String getAttrName() {
		return attrName;
	}

	@Override
	public String toString() {
		return ToStringBuilder.reflectionToString(this, ToStringStyle.MULTI_LINE_STYLE);
	}

}
