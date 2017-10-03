/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * InventoryTask.swift is part of FlyveMDMInventory
 *
 * FlyveMDMInventory is a subproject of Flyve MDM. Flyve MDM is a mobile
 * device management software.
 *
 * FlyveMDMInventory is Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ------------------------------------------------------------------------------
 * @author    Hector Rondon
 * @date      09/06/17
 * @copyright Copyright © 2017 Teclib. All rights reserved.
 * @license   Apache License, Version 2.0 https://www.apache.org/licenses/LICENSE-2.0
 * @link      https://github.com/flyve-mdm/flyve-mdm-ios-inventory
 * @link      https://flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

import Foundation
import UIKit

public class InventoryTask {

    public let memory = Memory()
    public let storage = Storage()
    public let hardware = Hardware()
    public let os = OperatingSystem()
    public let battery = Battery()
    public let cpu = Cpu()
    public let network = Network()
    public let carrier = Carrier()

    public init() {}

    /**
     Execute generate inventory
     
     - parameter versionClient: Cliente app identifier
     - returns: completion: (_ result: String) -> Void The XML String
     */
    public func execute(_ versionClient: String, tag: String = "", json: Bool = false, completion: (_ result: String) -> Void) {

        completion(self.createXML(versionClient, tag: tag, json: json))
    }

    /**
     Creates an invetory
     
     - parameter versionClient: Cliente app identifier
     - returns: The XML String
     */
    private func createXML(_ versionClient: String, tag: String, json: Bool) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let dateLog = dateFormatter.string(from: Date())
        let xml = "\(createDTD())" +
            createElement(
                tag: "REQUEST",
                value:
                createElement(tag: "QUERY", value: "INVENTORY") +
                    createElement(tag: "VERSIONCLIENT", value: versionClient) +
                    createElement(tag: "DEVICEID", value: "\(hardware.uuid() ?? "not available")") +
                    createElement(tag: "CONTENT", value:
                        createElement(tag: "ACCESSLOG", value:
                            createElement(tag: "LOGDATE", value: "\(dateLog)") +
                            createElement(tag: "USERID", value: "N/A")
                        ) +
                        createElement(tag: "ACCOUNTINFO", value:
                            createElement(tag: "KEYNAME", value: "TAG") +
                            createElement(tag: "KEYVALUE", value: "\(tag != "" ? tag : "N/A" )")
                        ) +
                        createElement(tag: "BIOS", value:
                            createElement(tag: "BMANUFACTURER", value: "\(hardware.gpuVendor() ?? "not available")") +
                            createElement(tag: "MMODEL", value: "\(hardware.identifier() ?? "not available")") +
                            createElement(tag: "SMODEL", value: "\(hardware.model() ?? "not available")")
                        ) +
                        createElement(tag: "HARDWARE", value:
                            createElement(tag: "NAME", value: "\(hardware.model() ?? "not available")") +
                            createElement(tag: "TYPE", value: "\(hardware.identifier() ?? "not available")") +
                            createElement(tag: "OSNAME", value: "\(os.name() ?? "not available")") +
                            createElement(tag: "OSVERSION", value: "\(os.version() ?? "not available")") +
                            createElement(tag: "OSCOMMENTS", value: "\(hardware.osVersion() ?? "not available")") +
                            createElement(tag: "ARCHNAME", value: "\(hardware.archName() ?? "not available")") +
                            createElement(tag: "UUID", value: "\(hardware.uuid() ?? "not available")") +
                            createElement(tag: "MEMORY", value: "\(memory.total())")
                        ) +
                        createElement(tag: "OPERATINGSYSTEM", value:
                            createElement(tag: "KERNEL_NAME", value: "\(os.kernelName() ?? "not available")") +
                            createElement(tag: "KERNEL_VERSION", value: "\(os.kernelVersion() ?? "not available")") +
                            createElement(tag: "NAME", value: "\(os.name() ?? "not available")") +
                            createElement(tag: "VERSION", value: "\(os.version() ?? "not available")") +
                            createElement(tag: "FULL_NAME", value: "\(os.fullName() ?? "not available")")
                        ) +
                        createElement(tag: "CPUS", value:
                            createElement(tag: "NAME", value: "\(hardware.archName() ?? "not available")") +
                            createElement(tag: "MANUFACTURER", value: "\(hardware.gpuVendor() ?? "not available")") +
                            createElement(tag: "CACHE", value: "\(cpu.l1icache() ?? "not available")") +
                            createElement(tag: "CORE", value: "\(cpu.physicalCpu() ?? "not available")") +
                            createElement(tag: "SPEED", value: "\(cpu.frequency() ?? "not available")") +
                            createElement(tag: "THREAD", value: "\(cpu.logicalCpu() ?? "not available")")
                        ) + "\(storage.partitions() ?? "")" +
                        createElement(tag: "MEMORIES", value:
                            createElement(tag: "CAPACITY", value: "\(memory.total())")
                        ) +
                        createElement(tag: "NETWORK", value:
                            createElement(tag: "TYPE", value: "\(network.type() ?? "not available")") +
                            createElement(tag: "MACADDR", value: "\(network.macAddress() ?? "not available")") +
                            createElement(tag: "IPADDRESS", value: "\(network.localIPAddress() ?? "not available")") +
                            createElement(tag: "IPSUBNET", value: "\(network.broadcastAddress() ?? "not available")") +
                            createElement(tag: "WIFI_SSID", value: "\(network.ssid() ?? "not available")") +
                            createElement(tag: "WIFI_BSSID", value: "\(network.bssid() ?? "not available")")
                        ) +
                        createElement(tag: "STORAGES", value:
                            createElement(tag: "DISKSIZE", value: "\(storage.total() ?? "not available")")
                        ) +
                        createElement(tag: "VIDEOS", value:
                            createElement(tag: "CHIPSET", value: "\(hardware.gpuVersion() ?? "not available")") +
                            createElement(tag: "NAME", value: "\(hardware.gpuVendor() ?? "not available")") +
                            createElement(tag: "RESOLUTION", value: "\(hardware.screenResolution() ?? "not available")")
                        ) +
                        createElement(tag: "SIMCARD", value:
                            createElement(tag: "OPERATOR_NAME", value: "\(carrier.name() ?? "not available")") +
                            createElement(tag: "COUNTRY_CODE", value: "\(carrier.countryCode() ?? "not available")") +
                            createElement(tag: "OPERATOR_CODE", value: "\(carrier.mobileNetworkCode() ?? "not available")")
                        ) +
                        createElement(tag: "CAMERAS", value:
                            createElement(tag: "RESOLUTION", value: "\(hardware.backCamera() ?? "not available")")
                        ) +
                        createElement(tag: "CAMERAS", value:
                            createElement(tag: "RESOLUTION", value: "\(hardware.frontCamera() ?? "not available")")
                        )
                )
        )
        
        if json {
            do {
                let xmlDictionary = try XMLReader.dictionary(xml)
                let jsonData = try JSONSerialization.data(withJSONObject: xmlDictionary, options: .prettyPrinted)
                let jsonString = String(data: jsonData, encoding: .utf8)
                
                return jsonString ?? ""
                
            } catch {
                return error.localizedDescription
            }
        } else {
            return xml
        }
    }

    /**
     Creates the XML DTD
     
     - returns: the XML DTD String
     */
    private func createDTD() -> String {
        return "<?xml version='1.0' encoding='utf-8' standalone='yes' ?>"
    }

    /**
     Creates the XML Element
     
     - returns: the XML Element String
     */
    private func createElement(tag: String, value: String) -> String {
        return "<\(tag.uppercased())>\(value)</\(tag.uppercased())>"
    }
}