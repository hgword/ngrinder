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
package org.ngrinder.operation.cotroller;

import org.ngrinder.common.controller.NGrinderBaseController;
import org.ngrinder.operation.service.SystemConfigService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * System configuration controller.
 * 
 * @author Alex Qin
 * @since 3.1
 */
@Controller
@RequestMapping("/operation/systemConfig")
@PreAuthorize("hasAnyRole('A')")
public class SystemConfigController extends NGrinderBaseController {

	@Autowired
	private SystemConfigService systemConfigService;

	/**
	 * open system configuration editor.
	 * 
	 * @param model
	 *            model.
	 * @return operation/systemConfig
	 */
	@RequestMapping("")
	public String openSystemConfiguration(Model model) {
		model.addAttribute("content", systemConfigService.getSystemConfigFile());
		return "operation/systemConfig";
	}

	/**
	 * Save system configuration.
	 * 
	 * @param model
	 *            model.
	 * @param content
	 *            file content.
	 * @return operation/systemConfig
	 */
	@RequestMapping("/save")
	public String saveSystemConfiguration(Model model, @RequestParam final String content) {
		model.addAttribute("success", systemConfigService.saveSystemConfigFile(content));
		return openSystemConfiguration(model);
	}
}
