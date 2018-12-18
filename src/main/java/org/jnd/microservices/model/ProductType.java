package org.jnd.microservices.model;

public enum ProductType {

    FOOD,
    GADGETS,
    CLOTHES;

    public String toString(){
        switch(this){
            case FOOD:
                return "food";
            case GADGETS:
                return "gadgets";
            case CLOTHES:
                return "clothes";
        }
        return null;
    }

    public static org.jnd.microservices.model.ProductType value(Class<org.jnd.microservices.model.ProductType> enumType, String value){
        if(value.equalsIgnoreCase(FOOD.toString()))
            return FOOD;
        else if(value.equalsIgnoreCase(GADGETS.toString()))
            return GADGETS;
        else if(value.equalsIgnoreCase(CLOTHES.toString()))
            return CLOTHES;
        else
            return null;
    }
}
