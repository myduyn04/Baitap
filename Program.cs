using System;
namespace baithi
{
    class Vaytien
    {
        public string  TenKH{get;set;}
        public int Tienvay{get;set;}
        public double tgthang{get;set;}
        public double laisuatvay{get;set;}
        public abstract void Nhap();
        public abstract void Xuat();
        public abstract void Tientra();


    }
    class VAYTINDUNG:Vaytien
    {
        public int Hanmuc{get;set;}
        public  overried Void Nhap()
        {
            
            Console.Write("Ten Khach Hang:");
            TenKH= Console.ReadLine();
            Console.Write("Tien Vay:");
            Tienvay= int.Parse(Console.ReadLine());
            Console.Write("Thoi gian thang:");
            tgthang= double.Parse(Console.ReadLine());
            Console.Write("lai suat vay:");
            laisuatvay= double.Parse(Console.ReadLine());
            Console.Write("Han Muc:");
            Hanmuc= int.Parse(Console.ReadLine());

        }
        public overried void Tientra()
        {
            int tienlaihangthang= Tienvay *laisuatvay/ tgthang;
            if(Tienvay ≤ Hanmuc)
            {
                
                if (tgthang<1)
                {
                    return Tienvay;
                }
                else
                {
                    return Tienvay / tgthang+ tienlaihangthang;
                    
                }
            }
        }
        public overried void Xuat()
        {
            Console.Write("Ten KHac Hang"+ TenKH);
            Console.Write("Tien Vay:"+ Tienvay);
            Console.Write("Thoi gian thang:"+ tgthang);
            Console.Write("lai suat vay:"+ laisuatvay);
            Console.Write("Han Muc:"+Hanmuc);

        }



    }
    class VAYTHECHAP:Vaytien
    {
        public double Trigia{get;set;}
        public overried void Nhap()
        {
            Console.Write("Ten Khach Hang:");
            TenKH= Console.ReadLine();
            Console.Write("Tien Vay:");
            Tienvay= int.Parse(Console.ReadLine());
            Console.Write("Thoi gian thang:");
            tgthang= double.Parse(Console.ReadLine());
            Console.Write("lai suat vay:");
            laisuatvay= double.Parse(Console.ReadLine());
            Console.Write("Tri gia the chap:");
            Trigia= double.Parse(Console.ReadLine());

        }
        public overried void Tientra()
        {
            int tienlaihangthang=Tienvay *laisuatvay / tgthang;
            if(Tienvay ≤  85 Trigia)
            {
                return Tienvay / tgthang+ tienlaihangthang;
               
            }
        }
        public overried  void  Xuat()
        {
            Console.Write("Ten KHac Hang"+ TenKH);
            Console.Write("Tien Vay:"+ Tienvay);
            Console.Write("Thoi gian thang:"+ tgthang);
            Console.Write("lai suat vay:"+ laisuatvay);
            Console.Write("Tri gia the chap:"+Trigia);
        }

    }
    class VayTHAUCHI:Vaytien
    {
        public int tienluong{get;set;}
        public overried void Nhap()
        {
            Console.Write("Ten Khach Hang:");
            TenKH= Console.ReadLine();
            Console.Write("Tien Vay:");
            Tienvay= int.Parse(Console.ReadLine());
            Console.Write("Thoi gian thang:");
            tgthang= double.Parse(Console.ReadLine());
            Console.Write("lai suat vay:");
            laisuatvay= double.Parse(Console.ReadLine());
            Console.Write("tien luong");
            tienluong= int.tienluong(Console.ReadLine());

        }
        public overried void Tientra()
        {
            int tienlaihangthang= Tienvay * laisuatvay / tgthang;
            if (Tienvay ≤ 10 tienluong)
            {
                return Tienvay/ tgthang + tienlaihangthang;
            }
        }

    }
    class NGANHANG
    {
        public string
    }
    class Program
    {
        static void Main(string[] args)
        {
            VAYTINDUNG td=new VAYTINDUNG();
            VAYTHECHAP tc= new VAYTHECHAP();
            VayTHAUCHI tchi =new VayTHAUCHI();

        }

    }

    

}

