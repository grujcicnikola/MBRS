package ${class.typePackage};
<#-- IMPORTS -->
<#list importedPackages as imports>
	<#if !imports?starts_with(class.typePackage)>
import ${imports};
	</#if>
</#list>

import javax.persistence.*;
import java.utils.*;


@Entity
@Table(name="${class.name?uncap_first}")
${class.visibility} class ${class.name} <#if (class.ancestor)??>extends ${class.ancestor}</#if> {  
<#list properties as property>
	<#if property.persistentCharacteristics??>   
      		<#if property.persistentCharacteristics.key>
      	@Id
      			<#if (property.persistentCharacteristics.generatedValue)??>
      	@GeneratedValue(strategy = GenerationType.${property.persistentCharacteristics.generatedValue})
      			</#if>
      		<#else>
      	@Column(<#rt>
		   <#if (property.name)??>
		       <#lt>name = "${property.name?lower_case}"<#rt>
		   </#if>
		   <#if (property.persistentCharacteristics.length)??>
		       <#lt><#if (property.name)??>, </#if>length = ${property.persistentCharacteristics.length}<#rt>
		   </#if>
		   <#if (property.persistentCharacteristics.precision)??>
		       <#lt><#if (property.name)?? || (property.persistentCharacteristics.length)??>, </#if>precision = ${property.persistentCharacteristics.precision}<#rt>
		   </#if>
		   <#if (property.persistentCharacteristics.unique)??>
		       <#lt><#if (property.name)?? || (property.persistentCharacteristics.length)?? || (property.persistentCharacteristics.precision)??>, </#if>unique = ${property.persistentCharacteristics.unique?c}<#rt>
		   </#if>
		   <#if property.lower == 0>
		       <#lt><#if (property.name)?? || (property.persistentCharacteristics.length)?? || (property.persistentCharacteristics.precision)?? || (property.persistentCharacteristics.unique)??>, </#if>nullable = true<#rt>
		   </#if>
		   <#lt>)
      	</#if>
    <#elseif property.linkedCharacteristics??>	   
    	<#if property.upper == -1 && property.linkedCharacteristics.oppositeUpper == -1>@ManyToMany<#elseif property.upper == -1 && property.linkedCharacteristics.oppositeUpper == 1>@OneToMany<#elseif property.upper == 1 && property.linkedCharacteristics.oppositeUpper == -1>@ManyToOne<#else>@OneToOne</#if><#rt>
	<#lt><#if (property.linkedCharacteristics.fetch)?? || (property.linkedCharacteristics.cascade)?? || (property.linkedCharacteristics.mappedBy)?? || (property.linkedCharacteristics.optional)?? || (property.linkedCharacteristics.orphanRemoval)??>(<#rt>
		<#if (property.linkedCharacteristics.cascade)??>
			<#lt>cascade = CascadeType.${property.linkedCharacteristics.cascade}<#rt>
		</#if>
		<#if (property.linkedCharacteristics.fetch)??>
			<#lt><#if (property.linkedCharacteristics.cascade)??>, </#if>fetch = FetchType.${property.linkedCharacteristics.fetch}<#rt>
		</#if>
		<#if (property.linkedCharacteristics.mappedBy)??>
			<#lt><#if (property.linkedCharacteristics.cascade)?? || (property.linkedCharacteristics.fetch)??>, </#if>mappedBy = "${property.linkedCharacteristics.mappedBy}"<#rt>
		</#if>
		<#if (property.linkedCharacteristics.optional)??>
			<#lt><#if (property.linkedCharacteristics.cascade)?? || (property.linkedCharacteristics.fetch)?? || (property.linkedCharacteristics.mappedBy)??>, </#if>optional = ${property.linkedCharacteristics.optional?c}<#rt>
		</#if>
		<#if (property.linkedCharacteristics.orphanRemoval)??>
			<#lt><#if (property.linkedCharacteristics.cascade)?? || (property.linkedCharacteristics.fetch)?? || (property.linkedCharacteristics.mappedBy)?? || (property.linkedCharacteristics.optional)??>, </#if>orphanRemoval = ${property.linkedCharacteristics.orphanRemoval?c}<#rt>
		</#if>
		<#lt>)
	<#else>
	
	</#if>
   	</#if>
   	<#if property.upper ==1>
   	${property.visibility?lower_case} ${property.type.name} ${property.name};
    
    <#elseif property.upper == -1>
   	${property.visibility?lower_case} List<${property.type.name}> ${property.name} = new ArrayList<${property.type.name}>();
   	
    <#else>   
    	<#list 1..property.upper as i>
      ${property.visibility?lower_case} ${property.type.name} ${property.name}${i};
	
		</#list>  
    </#if>     
</#list>
	public ${class.name}() {
		super();
	}
	
	public ${class.name}(<#list properties as property><#if property.upper == 1>${property.type.name} ${property.name}<#elseif property.upper == -1 >List<${property.type.name}> ${property.name}<#else></#if><#if property_has_next>, </#if></#list>){
		<#list properties as property>
		this.${property.name} = ${property.name};
		</#list>
	}

<#list properties as property>
	<#if property.upper == 1 >   
      	public ${property.type.name} get${property.name?cap_first}(){
           	return ${property.name};
      	}
      
      	public void set${property.name?cap_first}(${property.type.name} ${property.name}){
           	this.${property.name} = ${property.name};
      	}
      
    <#elseif property.upper == -1 >
      	public List<${property.type.name}> get${property.name?cap_first}(){
           	return ${property.name};
      	}
      
      	public void set${property.name?cap_first}( List<${property.type.name}> ${property.name}){
           	this.${property.name} = ${property.name};
      	}
      
    <#else>   
    	<#list 1..property.upper as i>
     	public ${property.type.name} get${property.name?cap_first}${i}(){
           	return ${property.name}${i};
      	}
      
      	public void set${property.name?cap_first}${i}(${property.type.name} ${property.name}${i}){
           	this.${property.name}${i} = ${property.name}${i};
      	}
            
		</#list>  
    </#if>     
</#list>

}
