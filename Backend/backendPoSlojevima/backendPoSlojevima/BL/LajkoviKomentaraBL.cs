using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.BL.Interfaces;
using backendPoSlojevima.Models;
using backendPoSlojevima.DAL.Interfaces;

namespace backendPoSlojevima.BL
{
    public class LajkoviKomentaraBL : ILajkoviKomentaraBL
    {
        private readonly ILajkoviKomentaraDAL _ILajkoviKomentaraDAL;
        private readonly List<LajkoviKomentara> lajkoviKomentara;
        private readonly IKorisnikBL _IKorisnikBL;

        public LajkoviKomentaraBL(ILajkoviKomentaraDAL ILajkoviKomentaraDAL, IKorisnikBL IKorisnikBL)
        {
            _ILajkoviKomentaraDAL = ILajkoviKomentaraDAL;
            lajkoviKomentara = _ILajkoviKomentaraDAL.getAllLajkovi();
            _IKorisnikBL = IKorisnikBL;
        }

        public void deleteLajkoveKomentaraByIdKorisnika(long idKorisnika)
        {
            List<LajkoviKomentara> listaLajkova = getLajkovekomenatarByKorisnikId(idKorisnika);
            _ILajkoviKomentaraDAL.deleteLajkoveKomentara(listaLajkova);
            
        }

        public void deleteLajkoveKomentaraByIdKomentara(long idKomentara)
        {
            List<LajkoviKomentara> listaLajkova = getLajkoveKomentaraByIdKomentara(idKomentara);
             _ILajkoviKomentaraDAL.deleteLajkoveKomentara(listaLajkova);
            
        }

        public List<LajkoviKomentara> getAllLajkovi()
        {
            return _ILajkoviKomentaraDAL.getAllLajkovi();
        }

        public long getBrojLajkovaByIdKomentara(long idKomentara)
        {
            long broj = lajkoviKomentara.Where(l => l.KomentarID == idKomentara).Count();
            return broj;
        }

        public List<Korisnik> getKorisnikeKojiLajkujuByIdKomentara(long idKomentara)
        {
            List<Korisnik> korisnici = new List<Korisnik>();
            var korisniciKojiSuLajkovali = lajkoviKomentara.Where(o => o.KomentarID == idKomentara);
            foreach (var korisnik in korisniciKojiSuLajkovali)
            {
                Korisnik kor = _IKorisnikBL.getKorisnikaById(korisnik.KorisnikID);
                korisnici.Add(kor);
            }
            return korisnici;
        }

        public List<LajkoviKomentara> getLajkovekomenatarByKorisnikId(long idKorisnika)
        {
            return lajkoviKomentara.Where(k => k.KorisnikID == idKorisnika).ToList();
        }

        public List<LajkoviKomentara> getLajkoveKomentaraByIdKomentara(long idKomentara)
        {
            return lajkoviKomentara.Where(l => l.KomentarID == idKomentara).ToList();
        }

        public void saveLajk(LajkoviKomentara data)
        {
            _ILajkoviKomentaraDAL.saveLajk(data);
        }

        public int getLajkKomentaraByIdKorisnika(long idKorisnika, long idKomentara)
        {
            return _ILajkoviKomentaraDAL.getLajkKomentaraByIdKorisnika(idKorisnika, idKomentara);
        }
    }
}
