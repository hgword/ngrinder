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
package org.ngrinder.tracking;

/**
 * Interface for logging adapter. You can hook up log4j, System.out or any other loggers you want.
 * 
 * @author : Siddique Hameed
 * @version : 0.1
 */

public interface LoggingAdapter {

	public void logError(String errorMessage);

	public void logMessage(String message);

}
